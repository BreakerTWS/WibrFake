module WibrFake
    class Monitor
        def self.on(iface)
            puts "Desactivando la interfaz"
            stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
            if(status_down.success?)
                puts "Activando modo monitor"
                stdout_monitor, stderr_monitor, status_monitor = Open3.capture3("iw dev #{iface} set type monitor")
                if(status_monitor.success?)
                    puts "Activando la interfaz"
                    stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                    if(status_up.success?)
                        puts "Monitor on"
                    end
                end
            end
        end

        def self.off(iface)
            puts "down"
            stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
            if(status_down.success?)
                puts "monitor"
                stdout_monitor, stderr_monitor, status_monitor = Open3.capture3("iw dev #{iface} set type managed")
                if(status_monitor.success?)
                    puts "up"
                    stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                    if(status_up.success?)
                        puts "Manager on"
                    end
                end
            end
        end

        def self.status(iface)
            stdout_network, stderr_network, status_network = Open3.capture3("iw dev #{iface} info")
            macaddress = String.new
            if(status_network.success?)
                if stdout_network.include?("type managed") or stdout_network.include?("type AP")
                    puts "\n\e[1;33m[\e[0mi\e[1;33m]\e[1;37m The status monitor mode is not activated"
                elsif stdout_network.include?("type monitor")
                    puts "\e[1;32m[\e[1;37m+\e[1;32m]\e[1;37m The status monitor mode is activated"
                end
            end
        end
    end
end
