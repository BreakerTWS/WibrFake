module WibrFake
    class Processes
        def self.status(process_name)
            pids = []
            Dir.entries('/proc').each do |entry|
                next unless entry =~ /^\d+$/ # Solo directorios numéricos (PIDs)
                comm_path = File.join('/proc', entry, 'comm')
                begin
                    cmdline = File.read(comm_path).strip
                    if cmdline.include?(process_name)
                        pids << entry.to_i
                    end
                    rescue Errno::ENOENT, Errno::EACCES
                        next
                    end
                end
            pids
        end
    end
end