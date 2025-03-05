module WibrFake
    class Listing
        def self.clients_connected(id: nil)
            begin
                dispositivos = Array.new
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'clients', 'clients_connected.log'), 'r'){|file|
                    file.each{|line|
                        dispositivos << {hostname: line.split(', ')[0], ip: line.split(', ')[1], mac: line.split(', ')[2].chomp}
                    }
                }
                if(dispositivos.empty?)
                    warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m No connected devices"
                else
                    puts "\n"
                    puts "\033[48;5;236m=" * 87
                    puts "|" + " "  + "#{"\033[38;5;196mID\e[1;37m"} | #{' ' * 8 + "\033[38;5;51mHostname\e[1;37m" + ' ' * 8} | #{' ' * 10 + "\033[38;5;118mIP\e[1;37m" + ' ' * 10} | #{' ' * 12 + "\033[38;5;214mMac\e[1;37m" + ' ' * 12 + "|"}"
                    puts "|" + "-" * 86
                    dispositivos.each_with_index{|client, index|
                        index += 1
                        puts "|" + ' ' * 2 + "#{index.to_s} | #{' ' * 4 + client[:hostname].ljust(18) + ' ' * 2} | #{' ' * 5 + client[:ip].ljust(16) +  " "} | #{' ' * 5 + client[:mac].ljust(10) +  " " * 5 + "|"}"
                    }
                    puts "=" * 87
                end
            rescue Errno::ENOENT
                warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m No connected devices"
            end
        end
        def self.clients_disconnected(id: nil)
            begin
                dispositivos = Array.new
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'clients', 'clients_disconnected.log'), 'r'){|file|
                    file.each{|line|
                        dispositivos << {hostname: line.split(', ')[0], ip: line.split(', ')[1], mac: line.split(', ')[2].chomp}
                    }
                }
                if(dispositivos.empty?)
                    warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m No devices are disconnected, so there are no logs of disconnected devices"
                else
                    puts "\n"
                    puts "\033[48;5;236m=" * 87
                    puts "|" + " "  + "#{"\033[38;5;196mID\e[1;37m"} | #{' ' * 8 + "\033[38;5;196mHostname\e[1;37m" + ' ' * 8} | #{' ' * 10 + "\033[38;5;196mIP\e[1;37m" + ' ' * 10} | #{' ' * 12 + "\033[38;5;196mMac\e[1;37m" + ' ' * 12 + "|"}"
                    puts "|" + "-" * 86
                    dispositivos.each_with_index{|client, index|
                        index += 1
                        puts "|" + ' ' * 2 + "#{index.to_s} | #{' ' * 4 + client[:hostname].ljust(18) + ' ' * 2} | #{' ' * 5 + client[:ip].ljust(16) +  " "} | #{' ' * 5 + client[:mac].ljust(10) +  " " * 5 + "|"}"
                    }
                    puts "=" * 87
                end
            rescue Errno::ENOENT
                warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m No devices are disconnected, so there are no logs of disconnected devices"
            end
        end
        def self.clients_logs(id: nil)
            begin
                dispositivos = Array.new
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'clients', 'clients.log'), 'r'){|file|
                    file.each{|line|
                        dispositivos << {time: line.split(',')[0].gsub('-0500', '').split.join(' '), hostname: line.split(',')[1].split[1], ip: line.split(',')[2].split[1], mac: line.split(',')[3].split[1], status: line.split(',')[4].split.join}
                    }
                }
                if(dispositivos.empty?)
                    warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m there is no record of devices that have interacted"
                else
                    puts "\n"
                    puts " " * 7 + "#{'Time' + ' ' * 18}   #{' ' + 'Hostname' + ' ' * 12}   #{'IP' + ' ' * 17}   #{'Mac' + ' ' * 14}   #{'Status' + ' ' * 6}"
                    puts " " * 7 + "----" + " " * 19 + "--------------" + ' ' * 10 + '------' + ' ' * 13 + '--------------' + ' ' * 10 + '--------'
                    dispositivos.each{|client|
                        puts "#{client[:time]}" + ' ' * 2 + "#{' ' * 8 + "#{client[:hostname]}".ljust(19)}   #{"#{client[:ip]}".ljust(13) +  ' '}   #{' ' * 4 + "#{client[:mac]}".ljust(17) +  ' ' }  #{' ' * 5 + "#{client[:status]}".ljust(10) + ' ' * 6}"
                    }
                end
            rescue Errno::ENOENT
                warn "\n\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m There is no record of devices that have interacted"
            end
        end
    end
end