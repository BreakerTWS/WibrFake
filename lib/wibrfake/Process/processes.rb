module WibrFake
    class Processes
        def self.status(process, verb=0)
            pids = []
            File.foreach(File.join(File.dirname(__FILE__), 'pids.log')){|file|
                if(file.include?(process))
                    [file].each{|line|
                        line.split("\n").each{|pid|
                            pids << pid.split[1]
                        }
                    }
                end
            }

            if(pids.empty?)
                return "\033[38;5;196moff\e[1;37m" if(verb==1)
                []
            else
                return "\033[38;5;46mon\e[1;37m" if(verb==1)
                return pids
            end
        end
        
        def self.status_proc(process)
            pids = Array.new
            Dir.entries('/proc').each do |entry|
                next unless entry =~ /^\d+$/ # Solo directorios numéricos (PIDs)
                comm_path = File.join('/proc', entry, 'comm')
                begin
                    cmdline = File.read(comm_path).strip
                    if cmdline.include?(process)
                        pids << entry.to_i
                    end
                rescue Errno::ENOENT, Errno::EACCES
                     next
                end
            end
            return pids
        end

        def self.status_all
            process = []
            File.foreach(File.join(File.dirname(__FILE__), 'pids.log')){|line|
                process << line if(!line.strip.empty?)
            }
            process
        end

        def self.set(process_name, pid)
            File.open(File.join(File.dirname(__FILE__), 'pids.log'), 'a'){|file|             
                file.write "\n#{process_name}: #{pid}"
            }
            [process_name, pid]
        end

        def self.del(pid)
            File.open(File.join(File.dirname(__FILE__), 'pids.log'), 'r+'){|file|
                lines = file.readlines
                lines.reject!{|line| line.include?(pid.to_s)}
                file.rewind
                file.write(lines.join)
                file.truncate(file.pos)
            }
        end
    end
end