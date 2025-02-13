#!/bin/env ruby
module WibrFake
    class CLI < String
        def initialize
            begin
                require_relative 'Rails/service'
                require_relative 'ty/prompt'
                require_relative 'ty/apld'
                require_relative 'String/string'
                require_relative 'Rails/login'
                require_relative 'NetworkInterface/monitor'
                require_relative 'NetworkInterface/mac'
                require_relative 'Listing/ouis'
                require_relative 'Listing/apfake'
                require_relative 'Listing/server'
                require_relative 'Config/options'
                require_relative 'Config/ipaddr'
                require_relative 'Config/security_wpa'
                require_relative 'Process/pkill'
                require_relative 'help'
            rescue LoadError => e
                puts e.message
                exit 1
            end
            @prompt = TTY::Prompt.new
            @configAP = OpenStruct.new
            @configAP = WibrFake::Config.apfake(@configAP)
            @configAP.ipaddr = WibrFake::IPAddr.new
        end
        def banner
            br_colorize """
             █     █░ ██▓ ▄▄▄▄    ██▀███    █████▒ ▄▄▄       ██ ▄█▀▓█████ 
            ▓█░ █ ░█░▓██▒▓█████▄ ▓██ ▒ ██▒▓██   ▒ ▒████▄     ██▄█▒ ▓█   ▀ 
            ▒█░ █ ░█ ▒██▒▒██▒ ▄██▓██ ░▄█ ▒▒████ ░ ▒██  ▀█▄  ▓███▄░ ▒███   
            ░█░ █ ░█ ░██░▒██░█▀  ▒██▀▀█▄  ░▓█▒  ░ ░██▄▄▄▄██ ▓██ █▄ ▒▓█  ▄ 
            ░░██▒██▓ ░██░░▓█  ▀█▓░██▓ ▒██▒░▒█░     ▓█   ▓██▒▒██▒ █▄░▒████▒
            ░ ▓░▒ ▒  ░▓  ░▒▓███▀▒░ ▒▓ ░▒▓░ ▒ ░     ▒▒   ▓▒█░▒ ▒▒ ▓▒░░ ▒░ ░
              ▒ ░ ░   ▒ ░▒░▒   ░   ░▒ ░ ▒░ ░        ▒   ▒▒ ░░ ░▒ ▒░ ░ ░  ░
              ░   ░   ▒ ░ ░    ░   ░░   ░  ░ ░      ░   ▒   ░ ░░ ░    ░   
                ░     ░   ░         ░                   ░  ░░  ░      ░  ░
                               ░ """
            puts_red "\e[4m\t\t\t\tBy Breaker #{WibrFake.version}\n", 1
        end

        def validate_iface(iface)
            stdout, stderr, status = Open3.capture3('iw dev')
            ifaces = []
            if(status.success?)
                stdout.each_line{|line|
                    if(line =~ /^\s*Interface\s+(\S+)/)
                        ifaces << $1
                    end
                }
                unless(ifaces.include?(iface))
                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m La interfaz #{iface}. no existe o no es una interfaz wifi"
                    exit 1
                end
            end
        end

        def start(options)
            validate_iface(options.iface)
            prompt = $prompt
            banner
            prompt_color_valid = "\n\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m"
            prompt_color_invalid = "\n\033[38;5;236m\e[0m\033[48;5;236m\033[38;5;196m✘ wibrfake  wlo1 \e[0m\033[38;5;196m\e[0m"
            commands = %w[help clear banner monitor mac apfake set run pkill show exit]
            loop do
                input =  @prompt.ask(prompt_color_valid) {|get|
                    get.required true
                }
                break if input =~ /^exit.*/i
                unless(input.empty?)
                    if(commands.include?(input.split.first))
                        #apfake_actived
                        prompt_color_valid = "\n\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m"
                        case input.split.first
                        when 'help'
                            WibrFake::Help.help
                        when 'clear'
                            system('clear')
                            banner
                        when 'banner'
                            banner
                        when 'show'
                            begin
                                case input.split.fetch(1)
                                when 'apfake'
                                    WibrFake::Listing.apfake_show(@configAP)
                                when 'server'
                                    WibrFake::Listing.server_show(@configAP)
                                when 'login'
                                    WibrFake::RailsLogin.show(1)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command show [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command show [options]. not found, Run the show command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when'set'
                            begin
                                case input.split.fetch(1)
                                when 'name'
                                    begin
                                        @configAP.name = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el nombre del punto de acceso"
                                    end
                                when 'password'
                                    begin
                                        @configAP.password = input.split.fetch(2)
                                        @configAP.required_pass = "yes"
                                        @configAP.wpa = "wpa2"
                                    rescue IndexError
                                        puts "Falta la contrasena del punto de acceso"
                                    end
                                when 'login'
                                    begin
                                        if(WibrFake::RailsLogin.validate?(input.split.fetch(2)))
                                            @configAP.login = input.split.fetch(2)
                                        else
                                            puts "login not found"
                                        end
                                    rescue IndexError
                                        puts "Falta el login del punto de acceso"
                                    end
                                when 'route'
                                    begin
                                        @configAP.login_route = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta la ruta del login"
                                    end
                                when 'port'
                                    begin
                                        @configAP.port = input.split.fetch(2).to_i
                                    rescue IndexError
                                        puts "Falta el puerto del login"
                                    end
                                when 'wp'
                                    begin
                                        if(input.split.fetch(2)=="wpa2") or (input.split.fetch(2)=="wpa") or (input.split.fetch(2)=="wep")
                                            @configAP.wpa = input.split.fetch(2)
                                            @configAP.wpa_pairwise = "CCMP" if(input.split.fetch(2)=="wpa")
                                            @configAP.wpa_key_mgmt = "WPA-PSK" if(input.split.fetch(2)=="wpa")
                                            @configAP.wpa_wep = @configAP.wpa=="wep"? "wep":nil
                                            @configAP.required_pass = "yes"
                                        else
                                            puts "Metodo de seguridad wpa no existe"
                                        end
                                    rescue IndexError
                                        puts "Falta el metodo de seguridad del punto de acceso"
                                    end
                                when 'pairwise'
                                    begin
                                        if(WibrFake::SecurityWPA.scan_pairwise(@configAP.wpa, input.split.fetch(2))==1)
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            puts "kndela"
                                            @configAP.wpa_pairwise = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        puts "Falta el cifrado de seguridad del punto de acceso"
                                    end
                                when 'key_mgmt'
                                    begin
                                        if(WibrFake::SecurityWPA.scan_mgmt(@configAP.wpa, input.split.fetch(2))==1)
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            puts "Kndela"
                                            @configAP.wpa_key_mgmt = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        puts "Falta el metodo de seguridad del punto de acceso"
                                    end
                                when 'gateway'
                                    begin
                                        @configAP.ipaddr = WibrFake::IPAddr.new(input.split.fetch(2))
                                    rescue IndexError
                                        puts "Falta el inet"
                                    rescue IPAddr::InvalidAddressError
                                        puts "Formato de ip erroneo"
                                    end
                                when 'mask'
                                    begin
                                        @configAP.ipaddr.defined_mask(input.split.fetch(2))
                                    rescue IndexError
                                        puts "Falta la mascara de red"
                                    end
                                when 'channel'
                                    begin
                                        @configAP.channel = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el canal"
                                    end
                                when 'server'
                                    begin
                                        @configAP.server = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el server"
                                    end
                                when 'server2'
                                    begin
                                        @configAP.server2 = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el server2"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [options]. not found, Run the show command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'run'
                            begin
                                case input.split.fetch(1)
                                when 'server'
                                    WibrFake::Rails.new(@configAP.host_server, @configAP.port, @configAP.login, @configAP.login_route).start
                                end
                            rescue IndexError
                                WibrFake::Config.new(@configAP, options.iface)
                                WibrFake::Apld.new(options.iface, @configAP.ipaddr,@configAP.ipaddr.ip_range)
                            end
                        when 'pkill'
                            begin
                                case input.split.fetch(1)
                                when 'all'
                                    WibrFake::Pkill.kill_all()
                                when 'dnsmasq'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                when 'hostapd'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                when 'wpa_supplicant'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command pkill [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command pkill [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'monitor'
                            begin
                                case input.split.fetch(1)
                                when 'on'
                                    WibrFake::Monitor.on(options.iface)
                                when 'off'
                                    WibrFake::Monitor.off(options.iface)
                                when 'status'
                                    WibrFake::Monitor.status(options.iface)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command monitor [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command monitor [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'mac'
                            begin
                                case input.split.fetch(1)
                                when 'show'
                                    WibrFake::Mac.show(options.iface)
                                when 'set'
                                    begin
                                        if(input.split.fetch(2))
                                            WibrFake::Mac.set(options.iface, input.split.fetch(2))
                                        end
                                    rescue IndexError
                                        puts "Falta de argumentos, la operacion mac set necesita una mac como entrada\n[mac set xx:xx:xx:xx:xx:xx]"
                                        prompt_color_valid = prompt_color_invalid
                                    end
                                when 'ramset'
                                    begin
                                        if(input.split.fetch(2))
                                            WibrFake::Mac.ramset(options.iface, input.split.fetch(2))
                                        end
                                    rescue IndexError
                                        WibrFake::Mac.ramset(options.iface)
                                    end
                                when 'list'
                                    begin
                                        if(input.split.fetch(2))
                                            WibrFake::Listing.ouis_mac(input.split.fetch(2), false)
                                        end
                                    rescue IndexError
                                        WibrFake::Listing.ouis_mac()
                                    end
                                when 'reset'
                                    WibrFake::Mac.reset(options.iface)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command mac [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command mac [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        end
                    else
                        puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command #{input}. not found, Run the help command for more details."
                        prompt_color_valid = prompt_color_invalid
                    end
                end
            end
        end
    end
    class GUI
        def self.start(options)
            puts "Continuara..."
        end
    end
end