module WibrFake
    class Rails
        def initialize(host, port, login, route)
            begin
                require 'puma'
                require_relative '../Rails/routes'
                require_relative '../../../config/environment'
            rescue LoadError
                puts "Error al cargar una libreria"
                exit(1)
            end
            @host = host
            @port = port
            @login = login
            @route = route
        end

        def start
            begin
                puma_server = Thread.new {
                    route_root, route_login = WibrFake::Rails.routes(@login, @route)
                    ::Rails.application.routes.clear!
                    ::Rails.application.routes.draw {
                        devise_for :users
                        root to: route_root[:sessions_get], as: route_root[:as_get]
                        get route_login[:route], to: route_login[:sessions_get], as: route_login[:as_get]
                        get route_login[:route], to: route_login[:sessions_post], as: route_login[:as_post]
                    }
                    Puma::Server.new(::Rails.application).tap {|server|
                        server.add_tcp_listener @host, @port
                    }.run.join
                }
            rescue
            ensure
                puts "Servidor lanzado correctamente"
            end
        end
    end
end