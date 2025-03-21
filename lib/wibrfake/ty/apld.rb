module WibrFake
    class Apld
      def initialize(iface, ipaddr, id)
        begin
          require 'pty'
          require 'packetfu'
          require 'concurrent'
          require 'thread'
          require_relative '../NetworkInterface/ip-routing'
          require_relative '../Dnsmasq/dnsmasq'
          require_relative '../Process/pkill'
        rescue LoadError => e
          puts "Error al incluir librerías: #{e.message}"
          exit(1)
        end
        @iface = iface
        @ipaddr = ipaddr
        @id = id
        server = WibrFake::Dnsmasq.new(ipaddr, id, iface)
        #WibrFake::Processes.status_proc("wpa_supplicant").each{|pid|
        #  WibrFake::Processes.set("wpa_supplicant", pid)
        #  WibrFake::Pkill.kill_silence("wpa_supplicant")
        #}

        #Run dnsmasq with PTY spawn
        begin
          raise Errno::EADDRINUSE if WibrFake::Processes.status_all.join.include?('dns') or WibrFake::Processes.status_all.join.include?('dhcp') or WibrFake::Processes.status_all.join.include?('hostapd')
          
          #Initiating IPRouting
          WibrFake::IPRouting.new(ipaddr, iface).set

          pid_hostapd = fork {
            $0 = 'wibrfake_hostapd'
            hostapd
          }
          pid_dns_server = fork {
            $0 = 'wibrfake_dns'
            server.dns
          }
          pid_dhcp_server = fork {
            $0 = 'wibrfake_dhcp'
            server.dhcp
          }
        rescue Errno::EADDRINUSE
          warn "An access point is running. View active processes with 'show process' and terminate the involved ones (dns, dhcp, hostapd) using 'pkill [PROCESS]'."
          return 0
        end

        #Set PID for process
        WibrFake::Processes.set("dns", String(pid_dns_server.to_i))
        WibrFake::Processes.set("dhcp", String(pid_dhcp_server.to_i))
        WibrFake::Processes.status_proc("hostapd").each{|pid|
          WibrFake::Processes.set("hostapd", pid)
        }
        
      end

      def hostapd
        begin
          status = 0
          PTY.spawn("hostapd #{File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'hostapd', 'hostapd.conf')}") do |r, w, pid|
            r.each_line { |line|
              if line =~ /ENABLE/
                if(status==1)
                  puts "\n\r\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Point access established"
                  puts "\n"
                  print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{@iface} \e[0m\033[38;5;236m\e[0m "
                end
                status += 1
              elsif line =~ /DISABLED/
                warn "\n\r\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m Fake access point was not launched correctly"
                puts "\n"
                print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{@iface} \e[0m\033[38;5;236m\e[0m "
                break
              elsif line =~ /DISCONNECTED/
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients_connected.log'), 'r+') do |file|
                  lines = file.readlines
                  target = line.split.last
                  lines.each{|client|
                    if client.include?(target)
                      File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients.log'), 'a'){|log|
                            log.write "#{Time.now}, Hostname: #{client.split(', ')[0]}, IP: #{client.split(', ')[1]}, Mac: #{client.split(', ')[2].chomp}, disconnect\n"
                      }
                      File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients_disconnected.log'), 'a'){|log|
                            log.write "#{client.split(', ')[0]}, #{client.split(', ')[1]}, #{client.split(', ')[2].chomp}\n"
                      }
                      warn "\n\n\r\033[38;5;196m[\e[1;37m✘\033[38;5;196m]\e[1;37m" + ' ' + "Dispositive: \033[38;5;51m#{client.split(', ')[0]}\e[1;37m | " + "IP: \033[38;5;118m#{client.split(', ')[1]}\e[1;37m | " + "MAC: \033[38;5;214m#{client.split(', ')[2].chomp}\e[1;37m" + ' ' + "disconnected"
                      puts "\n"
                      print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{@iface} \e[0m\033[38;5;236m\e[0m "
                      lines.reject! { |linefile| linefile.include?(target) }
                    end
                    file.rewind
                    file.write(lines.join)
                    file.truncate(file.pos)
                   }
                end
                
              elsif(line=~/already configured/)
                warn "\n\r\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m hostapd process is already being used. Kill the process with the `pkill hostapd` command"
                puts "\n"
                print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{@iface} \e[0m\033[38;5;236m\e[0m "
                break
              end
            }
          rescue
          end 
        end
      end
    end
  end