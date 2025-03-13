module WibrFake
    class RailsUsage
        def initialize
            begin
                require 'puma'
                require_relative '../Rails/routes'
                require_relative '../../../config/environment'
            rescue LoadError => e
                puts "Error al cargar una libreria"
                puts e.message
                exit(1)
            end
            @host = '0.0.0.0'
            @port = 1972
            @route = 'wibrfake/'
        end
        def start
            begin
                #server_pid = fork {
                    routes = WibrFake::Rails.usage(route: @route)
                    ::Rails.application.routes.clear!
                    
                    ::Rails.application.routes.draw {
                        devise_for :users
                        get routes[:route], to: routes[:sessions_get]
                        get routes[:route_about], to: routes[:sessions_get_about]
                    }
                    Puma::Server.new(::Rails.application).tap {|server|
                        server.add_tcp_listener @host, @port
                    }.run
                #}
                #WibrFake::Processes.set("web_server", server_pid)
                puts "\n\033[38;5;196m[\e[1;37m+\033[38;5;196m]\e[1;37m Wibrfake server to learn how to use it is mounted on:"
                puts "http://#{@host}:#{@port.to_s}/#{@route}"
                puts 'To exit use Ctrl + C'
                sleep
            rescue Interrupt
                exit(0)
            rescue => e
                puts e.message
            end
            #return {"#{server_pid}_#{@login}" => "http://#{@host}:#{@port}/#{@route}"}

        end
    end
end