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
                    Process.kill("TERM", input.to_i)
                    puts "Killed #{process_name}"
                elsif (input=="")
                    pids.each{|pid|
                        puts "Killing #{process_name} with PID: #{pid}"
                        Process.kill("TERM", pid.to_i)
                        puts "Killed #{process_name} with PID: #{pid}"
                    }
                end
            elsif(pids.length==1)
                puts "Killing #{process_name} with PID: #{pids[0]}"
                Process.kill("TERM", pids[0].to_i)
                sleep(1)
                puts "process killed #{process_name}"
                status = true
            end
            return status
        end

        def self.kill_all()
            processes_name = %w[hostapd dnsmasq wpa_supplicant]
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
                        Process.kill("TERM", input.to_i)
                        puts "Killed #{process_name}"
                    elsif (input=="")
                        pids.each{|pid|
                            puts "Killing #{process_name} with PID: #{pid}"
                            Process.kill("TERM", pid.to_i)
                            puts "Killed #{process_name} with PID: #{pid}"
                        }
                    end
                elsif(pids.length==1)
                    puts "Killing #{process_name} with PID: #{pids[0]}"
                    Process.kill("TERM", pids[0].to_i)
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
                    Process.kill("TERM", pid)
                }
            end
        end
        def self.kill_all_silence()
            processes_name = %w[hostapd dnsmasq]
            processes_name.each{|process_name|
                pids = WibrFake::Processes.status(process_name)
                if(pids.length>=1)
                    pids.each{|pid|
                        Process.kill("TERM", pid)
                    }
                end
            }
        end
    end
end