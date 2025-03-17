require_relative 'version'
module WibrFake
    class ParseOPT
        def initialize(options)
            begin
                require_relative 'Listing/wireless'
                require_relative 'wibrfake_cli'
            rescue LoadError => e
                puts e.message
                exit 1
            ensure
                wibrfake_cli = WibrFake::CLI.new
            end
            begin
                OptionParser.new do|param|
                    param.banner = "Usage: wibrfake --mode [MODE] --iface [INTERFACE]"
                    param.separator ''
                    param.on('-m', '--mode MODE', String, 'mode to init program in gui or cli'){|mode|options.mode=mode}
                    param.on('-i', '--iface INTERFACE', String, 'Assign to Network Interface to operate'){|iface|options.iface=iface}
                    param.on('-w', '--wkdump FILE', String, 'Map to wibrfake dump file'){|wkdump|options.file_wkdump=wkdump}
                    param.on('-l', '--list-interfaces', 'List the types of Wi-Fi network interfaces available'){WibrFake::Listing.wireless; exit 0}
                    param.on('-s', '--sessions', 'List the sessions actived'){
                        sessions = Array.new
                        Dir.each_child(File.join(File.dirname(__FILE__), 'Tmp')){|directory|
                            if(Dir.exist?(File.join(File.dirname(__FILE__), 'Tmp', directory)))
                                sessions << directory
                            end
                        }
                        if(sessions.empty?)
                            puts "Ninguna sesion de wibrfake esta activa"
                        else
                            puts "Sesiones activas:\n"
                            sessions.each_with_index{|session, index|
                            puts "\t#{index+1}: #{session}"
                            }
                        end
                    }
                    param.separator ''
                    param.on_tail('-u', '--usage', 'Launch usage server for wibrfake'){options.usage_server=true}
                    param.on_tail('-h', '--help', 'command to view help parameters'){puts param; exit}
                    param.on_tail('-V', '--version', 'show version'){puts "WibrFake version #{WibrFake.version}"; exit}
                end.parse!
            rescue OptionParser::MissingArgument => missing
                puts missing.message
                exit 1
            end

        #Validate Interface
        #Enter wibrfake mode
            if(Process.uid==0)
                if(!options.mode.nil?)
                    if options.mode == 'cli'
                        wibrfake_cli.start(options)
                    elsif options.mode == 'gui'
                        WibrFake::GUI.start(options)
                    else
                        abort "\e[31m[\e[37m✘\e[31m]\e[37m Invalid mode"
                    end
                elsif (!options.usage_server.nil?)
                    wibrfake_cli.start(options)
                end
            else
                puts "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m Access Denied"
                puts "\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m root privileges needed (Process UID 0)"
            end
        end
    end
end
