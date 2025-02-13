require 'concurrent'
require 'packetfu'

module WibrFake
  class Scanner
    def self.hosts(iface, range, mutex)
      num_threads = 10  # Hilos reducidos
      active_hosts = Set.new
      pool = Concurrent::ThreadPoolExecutor.new(max_threads: num_threads)
      running = true

      # Configurar un único socket
      cap = PacketFu::Capture.new(iface: iface, start: true)

      Signal.trap('INT') do
        running = false
        #cap.close
      end

      while running
        latch = Concurrent::CountDownLatch.new(range.size)

        range.each do |ip|
          pool.post do
            begin
              # Usar el socket compartido con mutex
              mac = mutex.synchronize do
                PacketFu::Utils.arp(ip, iface: iface, timeout: 0.05, cap: cap)
              end

              mutex.synchronize do
                if mac
                  unless active_hosts.include?(ip)
                    puts "Host activado #{ip} mac: #{mac}"
                    active_hosts.add(ip)
                  end
                end
              end
            rescue => e
              mutex.synchronize { #puts active_hosts.first=="172.168.1.151"? active_hosts:false
              if active_hosts.include?(ip)
                puts "Host desactivado #{ip}"
                active_hosts.delete(ip)
              end
            }
              #puts "Error: #{e.message}"
            ensure
              latch.count_down
            end
          end
        end

        latch.wait
        sleep 1  # Intervalo entre escaneos completos
      end

      pool.shutdown
      pool.wait_for_termination
      #cap.close
    end
  end
end