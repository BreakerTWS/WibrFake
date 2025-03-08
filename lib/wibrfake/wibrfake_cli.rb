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
                require_relative 'NetworkInterface/monitor'
                require_relative 'NetworkInterface/mac'
                require_relative 'Listing/ouis'
                require_relative 'Listing/apfake'
                require_relative 'Listing/web_server'
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
            options.server_web = Array.new
            options.uuid = WibrFake::UUID.session(options.iface)
            options.iface_init = options.iface
            options.uuid_init = options.uuid
            options.session = WibrFake::Session.new(id: options.uuid)
            banner(id: options.uuid)
            prompt_color_valid = "\n\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{options.iface} \e[0m\033[38;5;236m\e[0m"
            prompt_color_invalid = "\n\033[38;5;236m\e[0m\033[48;5;236m\033[38;5;196m✘ wibrfake  #{options.iface} \e[0m\033[38;5;196m\e[0m"
            commands = %w[help clear banner monitor web_server apfake clients session mac apfake set run pkill show exit]
            WibrFake::Config.new(@configAP, options.iface, options.uuid)
            unless(options.file_wkdump.nil?)
                dump = Array.new
                puts "\033[38;5;196m[\e[1;37m+\033[38;5;196m]\e[1;37m The session has been successfully loaded from a wkdump file"
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
                        @configAP.session_modified = true
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
                                when 'options'
                                    WibrFake::Listing.show_process(options.iface)
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
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command show [options]. not found, Run the show command for more details."
                                prompt_color_valid = prompt_color_invalid
                                
                            rescue Errno::ENOENT => e
                                puts e.message
                            end
                        when'set'
                            begin
                                case input.split.fetch(1)
                                when 'iface'
                                    begin
                                        if !(options.iface==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            options.iface = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            options.iface = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Network interface name is missing"
                                    end
                                when 'ssid'
                                    begin
                                        if !(@configAP.ssid==input.split[2..-1].join(" ")) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.ssid = input.split[2..-1].join(" ")
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.ssid = input.split[2..-1].join(" ")
                                        end
                                        
                                    rescue IndexError
                                        warn "Falta el nombre del punto de acceso"
                                    end
                                when 'password'
                                    begin
                                        if(@configAP.wpa.nil?)
                                            puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set password. not disponible, configure wpa authentication, use \"set wp [AUTHENTICATION]\""
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            if !(@configAP.password==input.split.fetch(2)) and @configAP.session_modified
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.password = input.split.fetch(2)
                                                @configAP.wpa = "wpa2"
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.password = input.split.fetch(2)
                                                @configAP.wpa = "wpa2"
                                            end
                                            
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access point password is missing"
                                    end
                                when 'driver'
                                    begin
                                        if !(@configAP.driver==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.driver = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.driver = input.split.fetch(2)
                                        end
                                        
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Network driver name missing"
                                    end
                                when 'ignore_ssid'
                                    begin
                                        if !(@configAP.ignore_ssid==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.ignore_ssid = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.ignore_ssid = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Ingore ssid configuration is missing"
                                    end
                                when 'hw_mode'
                                    begin
                                        if !(@configAP.hw_mode==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.hw_mode = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.hw_mode = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Hw mode missing"
                                    end
                                when 'login'
                                    begin
                                        if(WibrFake::RailsLogin.validate?(input.split.fetch(2)))
                                            if !(@configAP.login==input.split.fetch(2)) and @configAP.session_modified
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.login = input.split.fetch(2)
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.login = input.split.fetch(2)
                                            end   
                                        else
                                            puts "login not found"
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access point login is missing"
                                    end
                                when 'route'
                                    begin
                                        if !(@configAP.login_route==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.login_route = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.login_route = input.split.fetch(2)
                                        end 
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Web server login path missing"
                                    end
                                when 'port'
                                    begin
                                        if !(@configAP.port==input.split.fetch(2).to_i) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.port = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.port = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m The port is missing"
                                    end
                                when 'wp'
                                    begin
                                        if(input.split.fetch(2)=="wpa2") or (input.split.fetch(2)=="wpa") or (input.split.fetch(2)=="wep")
                                            if !(@configAP.wpa==input.split.fetch(2)) and @configAP.session_modified
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.wpa = input.split.fetch(2)
                                                @configAP.wpa_pairwise = "CCMP" if(input.split.fetch(2)=="wpa")
                                                @configAP.wpa_key_mgmt = "WPA-PSK" if(input.split.fetch(2)=="wpa")
                                                @configAP.wpa_wep = @configAP.wpa=="wep"? "wep":nil
                                                @configAP.required_pass = "yes"
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.wpa = input.split.fetch(2)
                                                @configAP.wpa_pairwise = "CCMP" if(input.split.fetch(2)=="wpa")
                                                @configAP.wpa_key_mgmt = "WPA-PSK" if(input.split.fetch(2)=="wpa")
                                                @configAP.wpa_wep = @configAP.wpa=="wep"? "wep":nil
                                                @configAP.required_pass = "yes"
                                            end
                                        elsif(input.split.fetch(2)=="nil") or (input.split.fetch(2)=="none")
                                            if !(@configAP.wpa==nil)
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.wpa = nil
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.wpa = nil
                                            end                                            
                                        else
                                            warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m WPA security method does not exist"
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access point security method is missing"
                                    end
                                when 'pairwise'
                                    begin
                                        if(WibrFake::SecurityWPA.scan_pairwise(@configAP.wpa, input.split.fetch(2))==1)
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            if !(@configAP.wpa_pairwise==input.split.fetch(2)) and @configAP.session_modified
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.wpa_pairwise = input.split.fetch(2)
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.wpa_pairwise = input.split.fetch(2)
                                            end
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access point security encryption is missing"
                                    end
                                when 'key_mgmt'
                                    begin
                                        if(WibrFake::SecurityWPA.scan_mgmt(@configAP.wpa, input.split.fetch(2))==1)
                                            prompt_color_valid = prompt_color_invalid
                                        else
                                            if !(@configAP.wpa_key_mgmt==input.split.fetch(2)) and @configAP.session_modified
                                                options.session.session_modified(status: true, id: options.uuid)
                                                @configAP.wpa_key_mgmt = input.split.fetch(2)
                                            elsif !(@configAP.session_modified)
                                                options.session.session_modified(status: false, id: options.uuid)
                                                @configAP.wpa_key_mgmt = input.split.fetch(2)
                                            end
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access point security method is missing"
                                    end
                                when 'gateway'
                                    begin
                                        if !(@configAP.ipaddr==WibrFake::IPAddr.new(input.split.fetch(2))) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.ipaddr = WibrFake::IPAddr.new(input.split.fetch(2))
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.ipaddr = WibrFake::IPAddr.new(input.split.fetch(2))
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Inet is missing"
                                    rescue IPAddr::InvalidAddressError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Wrong IP Format"
                                    end
                                when 'netmask'
                                    begin
                                        if !(@configAP.ipaddr.mask==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.ipaddr.defined_mask(input.split.fetch(2))
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.ipaddr.defined_mask(input.split.fetch(2))
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Net mask missing"
                                    end
                                when 'rekey'
                                    begin
                                        if !(@configAP.wpa_rekey==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.wpa_rekey = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.wpa_rekey = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m WPA rekey configuration is missing"
                                    end
                                when 'channel'
                                    begin
                                        if !(@configAP.channel==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.channel = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.channel = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m The channel is missing"
                                    end
                                when 'wmm'
                                    begin
                                        if !(@configAP.wmm==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.wmm = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.wmm = input.split.fetch(2)
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Missing if it enables virtualization or disables it"
                                    end
                                when 'credentials'
                                    begin
                                        if !(@configAP.path_credential==input.split.fetch(2)) and @configAP.session_modified
                                            options.session.session_modified(status: true, id: options.uuid)
                                            @configAP.path_credential = input.split.fetch(2)
                                        elsif !(@configAP.session_modified)
                                            options.session.session_modified(status: false, id: options.uuid)
                                            @configAP.path_credential = input.split.fetch(2)
                                        end
                                    rescue
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m The path where the credentials will be saved is missing"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command set [options]. not found, Run the show command for more details."
                                prompt_color_valid = prompt_color_invalid
                            end
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
                                when 'web_server'
                                    unless(WibrFake::Pkill.kill(input.split.fetch(1)))
                                        puts "#{input.split.fetch(1)} process not found running"
                                    end
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command pkill [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue Errno::ESRCH
                                warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m proceso no encontrado"
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
                        when 'web_server'
                            begin
                                case input.split.fetch(1)
                                when 'on'
                                    options.server_web << WibrFake::Rails.new(@configAP.host_server, @configAP.port, @configAP.login, @configAP.login_route, @configAP.path_credential, options.iface, options.uuid).start
                                when 'off'
                                    WibrFake::Pkill.kill_silence("web_server")
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
                                        warn "\e[1;33m[\e[1;37m-\e[1;33m]\e[1;37m You don't have any web server running"
                                    else
                                        puts "Running servers:"
                                        puts
                                        puts status
                                        puts "\nTo see the identification processes for each server running, run \"show process web_server\""
                                    end
                                when 'show'
                                    WibrFake::Listing.web_server_show(@configAP)
                                else
                                    puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command web_server [#{input.split.fetch(1)}]. not found, Run the help command for more details."
                                    prompt_color_valid = prompt_color_invalid
                                end
                            rescue IndexError
                                puts "\n\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Command web_server [options]. not found, Run the help command for more details."
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
                                    
                                when 'show'
                                    WibrFake::Listing.apfake_show(@configAP, options.iface)
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
                                        puts "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Lack of arguments, the mac set operation needs a mac as input\n[mac set xx:xx:xx:xx:xx:xx:xx]"
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
                                            puts "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m New session created: #{input.split.fetch(2)}"
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m You have not defined the name for the new session"
                                    end
                                when 'remove'
                                    begin
                                        if(input.split.fetch(2))
                                            if(options.session.remove(number: input.split.fetch(2), id: options.uuid))
                                                options.uuid = nil
                                            end
                                        end
                                    rescue IndexError
                                        puts "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m You have not defined which session you want to delete"
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
                                                warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m You haven't defined a name for the session"
                                            end
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Which session to rename has not been defined"
                                    end
                                when 'save'
                                    WibrFake::Config.new(@configAP, options.iface, options.uuid)
                                    options.session.save(id: options.uuid)
                                    @configAP.session_remove = false
                                when 'init'
                                    begin
                                        if(input.split.fetch(2))
                                            options.uuid = options.session.init(number: input.split.fetch(2))
                                            if(options.uuid)
                                                options.file_wkdump = File.join(File.dirname(__FILE__), 'Tmp', options.uuid, 'wkdump', "#{options.uuid}.wkdump")
                                                dump = Array.new
                                                File.open(options.file_wkdump, 'r').each{|wkdump|
                                                    dump << wkdump
                                                }
                                                inp = dump.each
                                            end
                                            @configAP.session_modified = false
                                        end
                                    rescue IndexError
                                        warn "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m The session to start has not been defined"
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