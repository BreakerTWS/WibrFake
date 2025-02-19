module WibrFake
    class IPRouting
        def initialize(ipaddr, iface)
            begin
                require 'open3'
                require_relative '../Config/ipaddr'
            rescue LoadError =>e
                puts e.message
                exit(1)
            end
            @ipaddr = ipaddr
            @ip = ipaddr.to_s
            @ip_prefix = ipaddr.succ(0)
            @mask = ipaddr.mask
            @mask_number = WibrFake::IPAddr.new(@mask).mask_number
            @iface = iface
            @ruta = false
        end

        def inspect
            "#<WibrFake IPRouting: IPv4:#{@ip}/#{@mask}>"
        end

        def ip_inspect
            stdout_route_show, stderr_route_show, status_route_show = Open3.capture3("ip address show dev #{@iface}")
            if(status_route_show.success?)
                stdout_route_show.split("\n").each{|route|
                    route.scan(/\b(?:\d{1,3}\.){3}\d{1,3}\b/){|ip|
                        if(/#{@ip.split('.')[0..2].join('.')}/ === ip) and (route.include?(@iface))
                            return route
                        end
                    }
                }
            end
            return nil
        end

        def ruta_inspect
            stdout_route_show, stderr_route_show, status_route_show = Open3.capture3("ip route show")
            if(status_route_show.success?)
                stdout_route_show.split("\n").each{|route|
                    if(route.include?("#{@ip}/#{@mask}")) and (route.include?(@iface))
                        return route
                    end
                }
            end
        end

        def ruta_add
            stdout_route_add, stderr_route_add, status_route_show_add = Open3.capture3("ip route add #{@ip_prefix}/#{@mask} via #{@ip} dev #{@iface}")
            if(status_route_show_add.success?)
                return ruta_inspect
            end
        end

        def set()
            stdout_set, stderr_set, status_set = Open3.capture3("ip addr add #{@ip}/#{@mask_number} dev #{@iface}")
            if(status_set.success?)
                puts "New IPv4: #{@ip}/#{@mask} established"
                unless(ruta_inspect.empty?)
                    puts "rute:"
                    puts ruta_inspect
                    return true
                else
                    puts "Assigning route for #{@ip}/#{@mask}:"
                    puts ruta_add
                    return true
                end
            else
                if(stderr_set.include?("Address already assigned"))
                    puts "Address already assigned IPv4 and Routing for interface #{@iface}"
                    print "Do you want to continue or restart the IP?(y/n)"
                    restart_ip = gets.chomp=="y"? true:false
                    if(restart_ip)
                        puts "[!] Eliminating IPv4: #{@ip}/#{@mask}"
                        stdout_del_ip, stderr_del_ip, status_del_ip = Open3.capture3("ip addr del #{@ip}/#{@mask_number} dev #{@iface}")
                        if(status_del_ip.success?)
                            sleep(1)
                            puts "Assigning new IPv4: #{@ip}/#{@mask}"
                            set
                        end
                    end
                end
            end
        end
        def del()
            stdout_del, stderr_del, status_del = Open3.capture3("ip addr del #{@ip}/#{@mask_number} dev #{@iface}")
            if(status_del.success?)
                puts "IPv4 #{@ip}/#{@mask} removed"
                return true
            else
                if(stderr_del.include?("Address not found"))
                    puts "IPv4 #{@ip}/#{@mask} address not found, could not be deleted"
                end
                return false
            end
        end
    end
end