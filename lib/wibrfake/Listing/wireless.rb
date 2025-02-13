module WibrFake
    class Listing
        def self.wireless
            stdout_ifaces, stderr_ifaces, status_ifaces = Open3.capture3('iw dev')
            if status_ifaces.success?
                ifaces = []
                stdout_ifaces.each_line{|line|
                    if line =~ /^\s*Interface\s+(\S+)/
                        ifaces << $1
                    end
                }
                if ifaces.empty?
                    puts "no se encontraron interfaces"
                else
                    puts "List of network interfaces available for use:\n"
                    ifaces.each {|line|
                        stdout_type, stderr_type, status_type = Open3.capture3("iw dev #{line} info")
                        if(status_type.success?)
                            if stdout_type.include?('type managed')
                                puts " " * 4 + "* #{line}\n" + " " * 8 + "type managed"
                            elsif stdout_type.include?('type monitor')
                                puts " " * 4 + "* #{line}\n" + " " * 8 + "type monitor"
                            end 
                        end
                    }
                end
            end
        end
    end
end