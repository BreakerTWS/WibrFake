module WibrFake
    class Mac
        def self.veryfi_oui(mac)
            require 'sqlite3'
            begin
                oui = String.new
                db = SQLite3::Database.new(File.join(File.dirname(__FILE__), '..', 'DataBase', 'ouis.db'))
                organization = "Desconocido"
            rescue
                puts "Falta la base de datos en la aplicacion"
            end
            oui = mac.slice(0, 8)
            db.execute("SELECT id, name FROM ouis_mac WHERE oui = ?", oui){|row|
                unless(row.empty?)
                    organization = row[1]
                end
            }
            organization
        end

        def self.show(iface)
            stdout_mac, stderr_mac, status_mac = Open3.capture3("ip link show #{iface}")
            if(status_mac.success?)
                macs = []
                stdout_mac.scan(/(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F]/i){|mac| macs << mac}
                current_mac, broadcast_mac, permanent_mac = macs
                permanent_mac = permanent_mac || current_mac
                organization_currentmac = veryfi_oui(current_mac)
                puts "\nCurrent Mac: " + current_mac
                puts "Organization of current mac: #{organization_currentmac}"
                puts "Broadcast Mac: " + broadcast_mac
                puts "Permanent Mac: " + permanent_mac
            end
        end

        def self.set(iface, mac)
            if(mac =~ /(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F]/i)
                veryfi_oui(mac)
                stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
                if(status_down.success?)
                    stdout_set_mac, stderr_set_mac, status_set_mac = Open3.capture3("ip link set #{iface} address #{mac}")
                    if(status_set_mac.success?)
                        stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                        if(status_up.success?)
                            puts "New mac: #{mac}"
                        end
                    end
                end
            end
        end

        def self.ramset(iface, oui_ramset=false)
            unless(oui_ramset)
                stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
                if(status_down.success?)
                    loop do
                        mac = 6.times.map{"%02x" % rand(256)}.join(':')
                        stdout_set_mac, stderr_set_mac, status_set_mac = Open3.capture3("ip link set #{iface} address #{mac}")
                        if(status_set_mac.success?)
                            stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                            if(status_up.success?)
                                puts "New mac ramdon: #{mac}"
                                break
                            end
                        end
                    end
                end
            else
                if(oui_ramset =~ /(?:[0-9A-F][0-9A-F][:\-]){2}[0-9A-F][0-9A-F]/i)
                    puts "OUI ingresado"
                    stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
                    if(status_down.success?)
                        mac = oui_ramset + ':' + 3.times.map{"%02x" % rand(256)}.join(':')
                        stdout_set_mac, stderr_set_mac, status_set_mac = Open3.capture3("ip link set #{iface} address #{mac}")
                        if(status_set_mac.success?)
                            stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                            if(status_up.success?)
                                puts "New mac random of ui: #{mac}"
                            end
                        end
                    end
                end
            end
        end
        def self.reset(iface)
            stdout_mac, stderr_mac, status_mac = Open3.capture3("ip link show #{iface}")
            if(status_mac.success?)
                macs = []
                stdout_mac.scan(/(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F]/i){|mac| macs << mac}
                current_mac, broadcast_mac, permanent_mac = macs
                permanent_mac = permanent_mac || current_mac
                if(permanent_mac==current_mac)
                    puts "La mac actual es la permanente, ningun cambio aplicado"
                else
                    puts "Mac ingresada"
                    stdout_down, stderr_down, status_down = Open3.capture3("ip link set dev #{iface} down")
                    if(status_down.success?)
                        puts "Interfaz desactivada"
                        stdout_set_mac, stderr_set_mac, status_set_mac = Open3.capture3("ip link set #{iface} address #{permanent_mac}")
                        if(status_set_mac.success?)
                            puts "Mac cambiada"
                            stdout_up, stderr_up, status_up = Open3.capture3("ip link set dev #{iface} up")
                            if(status_up.success?)
                                puts "Mac cambiada satisfactoriamente"
                            end
                        end
                    end
                end
            end
        end
    end
end