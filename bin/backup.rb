module WibrFake
    class Apld
        def self.start(range, iface)
            begin
                require 'pty'
                require 'packetfu'
            rescue LoadError => e
                puts "Error include library for project"
                puts e.message
                exit(1)
            end
            
            system('pkill hostapd')
            PTY.spawn('hostapd hostapd.conf'){|r, w, pid|
                Thread.new {
                r.each_line{|line|
                    if(line=~/DISABLED/)
                        puts "Punto de acceso no se lanzo"
                        exit(1)
                    elsif(line=~/AP-STA-DISCONNECTED/)
                        puts line
                    end
                }

                }

                    num_threads  = 25
                    active_hosts = Set.new
                    mutex = Mutex.new
                    loop do
                        threads = []
                        range.each_slice(num_threads).each {|ip_batch|
                            ip_batch.each {|ip|
                                threads << Thread.new {
                                    begin
                                        mac = PacketFu::Utils.arp(ip, :iface => iface, :timeout => 0.05)
                                        mutex.synchronize {
                                            if mac
                                                unless active_hosts.include?(ip)
                                                    puts "hots activado #{ip} mac: #{mac}"
                                                    active_hosts.add(ip)
                                                end
                                            else
                                                if active_hosts.include?(ip)
                                                    puts "host #{desactivado}"
                                                    active_hosts.delete(ip)
                                                end
                                            end
                                        }
                                    rescue => e
                                    end
                                }
                                

                            }
                            threads.each(&:join)
                        }
                    end
        end
    end
end
