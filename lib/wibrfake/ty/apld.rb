module WibrFake
    class Apld
      def initialize(iface, ipaddr)
        begin
          require 'pty'
          require 'packetfu'
          require 'concurrent'
          require_relative '../NetworkInterface/ip-routing'
          require_relative '../Process/pkill'
        rescue LoadError => e
          puts "Error al incluir librerías: #{e.message}"
          exit(1)
        end
        @iface = iface
        @ipaddr = ipaddr
        #Initiating IPRouting
        WibrFake::IPRouting.new(ipaddr, iface).set

        #Run dnsmasq with Open3
        pid_dnsmasq = fork {
          dnsmasq
        }

        #Run dnsmasq with PTY spawn
        pid_hostapd = fork {
          hostapd
          
        }

        #Set PID for process
        WibrFake::Processes.set("dnsmasq", String(pid_dnsmasq.to_i + 2))
        WibrFake::Processes.set("hostapd", String(pid_hostapd.to_i + 2))
      end

      def hostapd
        begin
          status = 0
          PTY.spawn('hostapd hostapd.conf') do |r, w, pid|
            r.each_line { |line|
              if line =~ /ENABLE/
                if(status==1)
                  puts "\n\r\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Point access established"
                  puts "\n"
                  print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{@iface} \e[0m\033[38;5;236m\e[0m "
                end
                status += 1
              elsif line =~ /DISABLED/
                warn "\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m Fake access point was not launched correctly"
                #@hostapd_success = false
                #@terminate = true
                break
              elsif(line=~/already configured/)
                warn "\e[1;33m[\e[1;37m!\e[1;33m]\e[1;37m hostapd process is already being used. Kill the process with the `pkill hostapd` command"
                #@hostapd_success = false
                #@terminate = true
                break
              end
              
            }
          rescue
          end 
        end
      end

      def dnsmasq
        stdout_dnsmasq, stderr_dnsmasq, status_dnsmasq = Open3.capture3('dnsmasq -C dnsmask.conf --keep-in-foreground')
        unless(status_dnsmasq.success?)
          if(stderr_dnsmasq.include?("already in use"))
            puts "dnsmasq process is already being used. Kill the process with the `pkill dnsmasq` command"
          else
            puts stderr_dnsmasq
          end
        end
      end
    end
  end