module WibrFake
    class Listing
        def self.clients_activated(id: nil)
            begin
                dispositivos = Array.new
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'clients', 'clients_activated.txt'), 'r'){|file|
                    file.each{|line|
                        dispositivos << {hostname: line.split(', ')[0], ip: line.split(', ')[1], mac: line.split(', ')[2].chomp}
                    }
                }
                if(dispositivos.empty?)
                    warn "Ningun dispositivo conectado aun"
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
                warn "Ningun dispositivo conectado aun"
            end
        end
    end
end