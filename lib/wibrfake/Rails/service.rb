module WibrFake
    class Rails
        def initialize(host, port, login, route, credential_route, iface, id)
            begin
                require 'puma'
                require_relative '../Rails/routes'
                require_relative '../../../config/environment'
            rescue LoadError => e
                puts "Error al cargar una libreria"
                puts e.message
                exit(1)
            end
            @host = host
            @port = port
            @login = login
            @route = route
            ENV['IFACE'] = iface
            ENV['ID'] = id
            ENV['CREDENTIAL_ROUTE'] = credential_route
        end
        def start
            begin
                server_pid = fork {
                    route_root, route_login = WibrFake::Rails.routes(login: @login, route: @route)
                    ::Rails.application.routes.clear!
                    
                    ::Rails.application.routes.draw {
                        devise_for :users
                        if(route_login[:route]=='/')
                            root to: route_root[:sessions_get], as: route_root[:as_get]
                        else
                            get route_login[:route_login], to: route_login[:sessions_get]
                            
                        end
                        get route_login[:route_generate_204], to: route_login[:sessions_get], as: route_login[:as_get]
                        post route_login[:route_generate_204], to: route_login[:sessions_post], as: route_login[:as_post]
                    }
                    Puma::Server.new(::Rails.application).tap {|server|
                        server.add_tcp_listener @host, @port
                    }.run
                    sleep
                }
                WibrFake::Processes.set("web_server", server_pid)
            rescue => e
                puts e.message
            end
            return {"#{server_pid}_#{@login}" => "http://#{@host}:#{@port}/#{@route}"}
        end
    end
end