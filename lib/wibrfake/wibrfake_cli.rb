#!/bin/env ruby
module WibrFake
    class CLI < String
        def initialize
            begin
                require 'fileutils'
                require 'yaml'
                require_relative 'Rails/service'
                require_relative 'ty/prompt'
                require_relative 'ty/apld'
                require_relative 'String/string'
                require_relative 'Rails/login'
                require_relative 'Scanner/active-hosts'
                require_relative 'NetworkInterface/monitor'
                require_relative 'NetworkInterface/mac'
                require_relative 'Listing/ouis'
                require_relative 'Listing/apfake'
                require_relative 'Listing/server'
                require_relative 'Listing/arp_scan'
                require_relative 'Listing/clients'
                require_relative 'Listing/sessions'
                require_relative 'Config/options'
                require_relative 'Config/ipaddr'
                require_relative 'Config/security_wpa'
                require_relative 'Process/pkill'
                require_relative 'Listing/process'
                require_relative 'Process/processes'
                require_relative 'Process/id'
                require_relative 'Sessions/session'
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
        def banner(id: nil)
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
            puts_red "\e[4m\t\t\t\tBy BreakerTWS #{WibrFake.version}\n", 1
            puts "\n\033[38;5;196m[\e[1;37m+\033[38;5;196m]\e[1;37m session id: #{id}"

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
            options.server_web = Array.new
            options.scan_arp = Array.new
            options.uuid = WibrFake::UUID.session(options.iface)
            options.iface_init = options.iface
            options.uuid_init = options.uuid
            options.session = WibrFake::Session.new(id: options.uuid)
            banner(id: options.uuid)
            prompt_color_valid = "\n\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{options.iface} \e[0m\033[38;5;236m\e[0m"
            prompt_color_invalid = "\n\033[38;5;236m\e[0m\033[48;5;236m\033[38;5;196m✘ wibrfake  #{options.iface} \e[0m\033[38;5;196m\e[0m"
            commands = %w[help clear banner monitor server arp_scan apfake clients session mac apfake set run pkill show exit]
            WibrFake::Config.new(@configAP, options.iface, options.uuid)
            unless(options.file_wkdump.nil?)
                dump = Array.new
                puts "File wkdump loaded"
                File.open(options.file_wkdump, 'r').each{|wkdump|
                    dump << wkdump
                }
                inp = dump.each
            end
            loop do
                unless(options.file_wkdump.nil?)
                    begin
                        input = inp.next
                    rescue StopIteration
                        options.file_wkdump = nil
                    end
                end
                if(options.file_wkdump.nil?)
                    input = @prompt.ask(prompt_color_valid) {|get|
                        get.required true
                    }
                end
                if(true)
                    if(commands.include?(input.split.first))
                        #apfake_actived
                        prompt_color_valid = "\n\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m"
                        case input.split.first
                        when 'exit'
                            WibrFake::Pkill.kill_all()
                            WibrFake::Listing.sessions_list_return.each{|session|
                                config_yml = YAML.load_file(File.join(File.dirname(__FILE__), 'Tmp', session, 'config.yml'))
                                if(!(config_yml['session']['session_save']))
                                    FileUtils.rm_rf(File.join(File.dirname(__FILE__), 'Tmp', session))
                                end
                            }
                            break
                        when 'help'
                            WibrFake::Help.help
                        when 'clear'
                            system('clear')
                            banner(id: options.uuid)
                        when 'banner'
                            banner(id: options.uuid)
                        when 'show'
                            begin
                                case input.split.fetch(1)
                                when 'apfake'
                                    WibrFake::Listing.apfake_show(@configAP, options.iface)
                                when 'server'
                                    WibrFake::Listing.server_show(@configAP)
                                when 'arp_scan'
                                    WibrFake::Listing.arp_scan_show(@configAP)
                                when 'process'
                                    begin
                                        WibrFake::Processes.status(input.split.fetch(2)).each{|process|
                                            if(process.empty?)
                                                warn "Process not found"
                                            else
                                                puts "#{input.split.fetch(2)}: #{process}"
                                            end
                                        }
                                    rescue IndexError
                                        puts WibrFake::Processes.status_all
                                    end
                                when 'login'
                                    WibrFake::RailsLogin.show(1)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command show [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                #puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command show [options]. not found, Run the show command for more details."
                                #prompt_color_valid = prompt_color_invalid
                                WibrFake::Listing.show_process(options.iface)
                            rescue Errno::ENOENT => e
                                puts e.message
                            end
                        when'set'
                            begin
                                case input.split.fetch(1)
                                when 'iface'
                                    begin
                                        options.iface = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el nombre de la interfaz de red"
                                    end
                                when 'ssid'
                                    begin
                                        @configAP.ssid = input.split[2..-1].join(" ")
                                    rescue IndexError
                                        puts "Falta el nombre del punto de acceso"
                                    end
                                when 'password'
                                    begin
                                        if(@configAP.wpa.nil?)
                                            puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set password. not disponible, configure wpa authentication, use \"set wp [AUTHENTICATION]\""
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            @configAP.password = input.split.fetch(2)
                                            @configAP.wpa = "wpa2"
                                        end
                                    rescue IndexError
                                        puts "Falta la contrasena del punto de acceso"
                                    end
                                when 'driver'
                                    begin
                                        @configAP.driver = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el nombre del driver de la red"
                                    end
                                when 'ignore_ssid'
                                    begin
                                        @configAP.ignore_ssid = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el la configuracion de ingore ssid"
                                    end
                                when 'hw_mode'
                                    begin
                                        @configAP.hw_mode = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el modo hw"
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
                                        elsif(input.split.fetch(2)=="nil") or (input.split.fetch(2)=="none")
                                            @configAP.wpa = nil
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
                                        @configAP.host_scan_arp = @configAP.ipaddr
                                    rescue IndexError
                                        puts "Falta el inet"
                                    rescue IPAddr::InvalidAddressError
                                        puts "Formato de ip erroneo"
                                    end
                                when 'netmask'
                                    begin
                                        @configAP.ipaddr.defined_mask(input.split.fetch(2))
                                    rescue IndexError
                                        puts "Falta la mascara de red"
                                    end
                                when 'rekey'
                                    begin
                                        @configAP.wpa_rekey = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta la configuracion de wpa rekey"
                                    end
                                when 'channel'
                                    begin
                                        @configAP.channel = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el canal"
                                    end
                                when 'wmm'
                                    begin
                                        @configAP.wmm = input.split.fetch(2)
                                    rescue IndexError
                                        puts "Falta el si habilita la virtualicacion o la desabilita"
                                    end
                                when 'host'
                                    begin
                                        @configAP.host_scan_arp = WibrFake::IPAddr.new(input.split.fetch(2))
                                        @configAP.host_init_scan_arp = @configAP.host_scan_arp.to_s
                                        @configAP.host_last_scan_arp = @configAP.host_scan_arp.succ("254")
                                    rescue IndexError
                                        puts "Falta el host"
                                    end
                                when 'host_init'
                                    begin
                                        @configAP.host_init_scan_arp = input.split.fetch(2)
                                        @configAP.host_scan_arp = WibrFake::IPAddr.new(WibrFake::IPAddr.init(input.split.fetch(2)))
                                    rescue IndexError
                                        puts "Falta el host inicial"
                                    end
                                when 'host_last'
                                    begin
                                        @configAP.host_last_scan_arp = input.split.fetch(2)
                                        @configAP.host_scan_arp = WibrFake::IPAddr.new(WibrFake::IPAddr.init(input.split.fetch(2)))
                                    rescue
                                        puts "Falta el host final"
                                    end
                                when 'credentials'
                                    begin
                                        @configAP.path_credential = input.split.fetch(2)
                                    rescue
                                        puts "Falta la ruta donde se va a guardar las credenciales"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [options]. not found, Run the show command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        #when 'run'
                        #    begin
                        #        case input.split.fetch(1)
                        #        when 'server'
                        #            WibrFake::Rails.new(@configAP.host_server, @configAP.port, @configAP.login, @configAP.login_route).start
                        #        end
                        #    rescue IndexError
                        #        WibrFake::Config.new(@configAP, options.iface)
                        #        WibrFake::Apld.new(options.iface, @configAP.ipaddr,@configAP.ipaddr.ip_range)
                        #    end
                        when 'pkill'
                            begin
                                case input.split.fetch(1)
                                when 'all'
                                    WibrFake::Pkill.kill_all()
                                when 'dns'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                when 'dhcp'
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
                                when 'server'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                when 'arp_scan'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command pkill [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue Errno::ESRCH
                                puts "proceso no encontrado"
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
                        when 'server'
                            begin
                                case input.split.fetch(1)
                                when 'on'
                                    options.server_web << WibrFake::Rails.new(@configAP.host_server, @configAP.port, @configAP.login, @configAP.login_route, @configAP.path_credential, options.iface, options.uuid).start
                                when 'off'
                                    WibrFake::Pkill.kill_silence("server")
                                    
                                when 'status'
                                    status = Array.new
                                    if(!options.server_web.empty?)
                                        options.server_web.each{|server_web|
                                            WibrFake::RailsLogin.show(0).each{|login|
                                                WibrFake::Processes.status("server").each{|server_pid|
                                                    if(server_web.include?("#{server_pid}_#{login}"))
                                                        status << "#{login}: #{server_web["#{server_pid}_#{login}"]}"
                                                    end
                                                }
                                            }
                                        }
                                    end
                                    if(status.empty?)
                                        warn "\e[1;33m[\e[1;37mi\e[1;33m]\e[1;37m no tienes ningun servidor web corriendo"
                                    else
                                        puts "Running servers:"
                                        puts
                                        puts status
                                        puts "\nTo see the identification processes for each server running, run \"show process server\""
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command server [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command server [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'arp_scan'
                            begin
                                case input.split.fetch(1)
                                when 'on'
                                    if(@configAP.host_init_scan_arp.nil?) and (@configAP.host_last_scan_arp.nil?)
                                        WibrFake::Scanner.hosts(iface: options.iface, range: @configAP.host_scan_arp.range(@configAP.host_init_scan_arp, @configAP.host_last_scan_arp))
                                    else
                                        WibrFake::Scanner.hosts(iface: options.iface, ipaddr: @configAP.host_scan_arp)
                                    end
                                    options.scan_arp << {host: @configAP.host_scan_arp.to_s, mask: @configAP.host_scan_arp.mask}
                                when 'off'
                                    WibrFake::Pkill.kill_silence("arp_scan")
                                when 'status'
                                    status = Array.new
                                    WibrFake::Processes.status("arp_scan").each{|scan_pid|
                                        status << scan_pid
                                    }
                                    if(status.empty?)
                                        warn "\e[1;33m[\e[1;37mi\e[1;33m]\e[1;37m You don't have any host scanners by ARP running"
                                        if(options.scan_arp.include?(host: @configAP.host_scan_arp.to_s))
                                            options.scan_arp.delete(host: @configAP.host_scan_arp.to_s)
                                        end
                                    else
                                        options.scan_arp.each{|scan|
                                            puts "ARP scan running in #{scan[:host]}/#{scan[:mask]}"
                                        }
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command arp_scan [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command arp_scan [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'apfake'
                            begin
                                case input.split.fetch(1)
                                when 'on'
                                    WibrFake::Config.new(@configAP, options.iface, options.uuid)
                                    WibrFake::Apld.new(options.iface, @configAP.ipaddr, options.uuid)
                                when 'off'
                                    WibrFake::Pkill.kill_silence("dns")
                                    WibrFake::Pkill.kill_silence("dhcp")
                                    WibrFake::Pkill.kill_silence("hostapd")
                                when 'status'
                                    
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command apfake [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command apfake [options]. not found, Run the help command for more details."
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
                        when 'clients'
                            begin
                                case input.split.fetch(1)
                                when 'connected'
                                    WibrFake::Listing.clients_connected(id: options.uuid)
                                when 'disconnected'
                                    WibrFake::Listing.clients_disconnected(id: options.uuid)
                                when 'logs'
                                    WibrFake::Listing.clients_logs(id: options.uuid)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command clients [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command clients [options]. not found, Run the help command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
                        when 'session'
                            begin
                                case input.split.fetch(1)
                                when 'list'
                                    WibrFake::Listing.sessions_list(id: options.uuid)
                                when 'new'
                                    begin
                                        if(input.split.fetch(2))
                                            WibrFake::Session.new(id: input.split.fetch(2))
                                            WibrFake::Config.new(WibrFake::Config.apfake(OpenStruct.new), options.iface_init, input.split.fetch(2))
                                            puts "[+] Nueva sesion creada: #{input.split.fetch(2)}"
                                        end
                                    rescue IndexError
                                        warn "No ha definido el nombre para la nueva sesion"
                                    end
                                when 'remove'
                                    begin
                                        if(input.split.fetch(2))
                                            options.session.remove(number: input.split.fetch(2))
                                        end
                                    rescue IndexError
                                        puts "No ha definido que sesion desea borrar"
                                    end
                                when 'rename'
                                    begin
                                        if(input.split.fetch(2))
                                            begin
                                                if(input.split.fetch(3))
                                                    if(options.session.rename(number: input.split.fetch(2), name: input.split.fetch(3), id: options.uuid)=='current')
                                                        options.uuid = input.split.fetch(3)
                                                    end
                                                end
                                            rescue IndexError
                                                warn "No ha definido un nombre para la sesion"
                                            end
                                        end
                                    rescue IndexError
                                        warn "No se ha definido a que sesion renombrar"
                                    end
                                when 'save'
                                    WibrFake::Config.new(@configAP, options.iface, options.uuid)
                                    options.session.save(id: options.uuid)
                                    @configAP.session_remove = false
                                when 'init'
                                    begin
                                        if(input.split.fetch(2))
                                            options.uuid = options.session.init(number: input.split.fetch(2))
                                            options.file_wkdump = File.join(File.dirname(__FILE__), 'Tmp', options.uuid, 'wkdump', "#{options.uuid}.wkdump")
                                            dump = Array.new
                                            File.open(options.file_wkdump, 'r').each{|wkdump|
                                                dump << wkdump
                                            }
                                            inp = dump.each
                                        end
                                    rescue IndexError
                                        warn "No se ha definido la sesion a iniciar"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command session [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command session [options]. not found, Run the help command for more details."
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