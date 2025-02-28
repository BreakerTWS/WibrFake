require_relative 'processes'
module WibrFake
    class Pkill
        def self.kill(process_name)
            status = false
            pids = WibrFake::Processes.status(process_name)
            if(pids.length>1)
                pids.each{|pid|
                    puts "Process #{process_name} with PID #{pid} found"
                }
                puts "Select the process to kill or press [ENTER] to kill all:"
                input = gets.chomp
                if(input.to_i>0) and (pids.include?(input))
                    puts "Killing #{process_name} with PID: #{input.to_i}"
                    begin
                        Process.kill("TERM", input.to_i)
                        WibrFake::Processes.del(input)
                    rescue Errno::ESRCH
                        WibrFake::Processes.del(input)
                    end
                    puts "Killed #{process_name}"
                elsif (input=="")
                    pids.each{|pid|
                        puts "Killing #{process_name} with PID: #{pid}"
                        begin
                            Process.kill("TERM", pid.to_i)
                            WibrFake::Processes.del(pid)
                        rescue Errno::ESRCH
                            WibrFake::Processes.del(pid)
                        end
                        puts "Killed #{process_name} with PID: #{pid}"
                    }
                end
            elsif(pids.length==1)
                puts "Killing #{process_name} with PID: #{pids[0]}"
                begin
                    Process.kill("TERM", pids[0].to_i)
                    WibrFake::Processes.del(pids[0])
                rescue Errno::ESRCH
                    WibrFake::Processes.del(pids[0])
                end
                sleep(1)
                puts "process killed #{process_name}"
                status = true
            end
            return status
        end

        def self.kill_all()
            processes_name = %w[hostapd wpa_supplicant server arp_scan dns dhcp]
            processes_name.each{|process_name|
                pids = WibrFake::Processes.status(process_name)
                if(pids.length>1)
                    pids.each{|pid|
                        puts "Process #{process_name} with PID #{pid} found"
                    }
                    puts "Select the process to kill or press [ENTER] to kill all:"
                    input = gets.chomp
                    if(input.to_i>0) and (pids.include?(input))
                        puts "Killing #{process_name} with PID: #{input.to_i}"
                        begin
                            Process.kill("TERM", input.to_i)
                            WibrFake::Processes.del(input)
                        rescue Errno::ESRCH
                            WibrFake::Processes.del(input)
                        end
                        puts "Killed #{process_name}"
                    elsif (input=="")
                        pids.each{|pid|
                            puts "Killing #{process_name} with PID: #{pid}"
                            begin
                                Process.kill("TERM", pid.to_i)
                                WibrFake::Processes.del(pid)
                            rescue Errno::ESRCH
                                WibrFake::Processes.del(pid)
                            end
                            puts "Killed #{process_name} with PID: #{pid}"
                        }
                    end
                elsif(pids.length==1)
                    puts "Killing #{process_name} with PID: #{pids[0]}"
                    begin
                        Process.kill("TERM", pids[0].to_i)
                        WibrFake::Processes.del(pids[0].to_i)
                    rescue Errno::ESRCH
                        WibrFake::Processes.del(pids[0].to_i)
                    end
                    sleep(1)
                    puts "process killed #{process_name}"
                    status = true
                end
            }
        end
        def self.kill_silence(process_name)
            pids = WibrFake::Processes.status(process_name)
            if(pids.length>=1)
                pids.each{|pid|
                    begin
                        Process.kill("TERM", pid.to_i)
                        WibrFake::Processes.del(pid.to_i)
                    rescue Errno::ESRCH
                        WibrFake::Processes.del(pid)
                    end
                }
            end
        end
        def self.kill_all_silence()
            processes_name = %w[hostapd dnsmasq wpa_supplicant server scan_arp]
            processes_name.each{|process_name|
                pids = WibrFake::Processes.status(process_name)
                if(pids.length>=1)
                    pids.each{|pid|
                        begin
                            Process.kill("TERM", pid)
                            WibrFake::Processes.del(pid)
                        rescue Errno::ESRCH
                            WibrFake::Processes.del(pid)
                        end
                    }
                end
            }
        end
    end
end