require 'concurrent'
require 'packetfu'

#$stderr.reopen(File.join(File.dirname(__FILE__), "warning.log"))
   
module WibrFake
  class Scanner
    def self.hosts(iface: nil, ipaddr: nil, range: nil)
      begin
        require_relative '../NetworkInterface/ip-routing'
      rescue LoadError => e
        puts "Error al incluir librerías: #{e.message}"
        exit(1)
      end

      if(ipaddr.nil?)
        ipaddr = WibrFake::IPAddr.new(range[0])
      end

      if(WibrFake::IPRouting.new(ipaddr, iface).ip_inspect.nil?)
        warn "\e[1;33m[\e[1;37mi\e[1;33m]\e[1;37m The ip set to do an arp scan does not exist for the interface #{iface}"
        return nil
      end
      active_hosts = Set.new
      range = ipaddr.ip_range
      pool = Concurrent::ThreadPoolExecutor.new(max_threads: 25)
      cap = PacketFu::Capture.new(iface: iface, start: true)
      scan_pid = fork {
        while true
          latch = Concurrent::CountDownLatch.new(range.size)

          range.each do |ip|
            pool.post do
              begin
                  mac = PacketFu::Utils.arp(ip, iface: iface, timeout: 0.05, cap: cap)
                  if mac
                    unless active_hosts.include?(ip)
                      puts "\n\rHost activado #{ip} mac: #{mac}"
                      puts "\n"
                      print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{iface} \e[0m\033[38;5;236m\e[0m "
                      active_hosts.add(ip)
                    end
                  end
              rescue => e
                if active_hosts.include?(ip)
                  puts "Host Disabled #{ip}"
                  active_hosts.delete(ip)
                end
              ensure
                latch.count_down
              end
            end
          end
          latch.wait
        end
      }
      WibrFake::Processes.set("arp_scan", scan_pid)
    end
  end
end