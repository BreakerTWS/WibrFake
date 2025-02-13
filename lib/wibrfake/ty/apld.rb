module WibrFake
    class Apld
      def initialize(iface, ipaddr, range)
        begin
          require 'thread'
          require 'pty'
          require 'packetfu'
          require 'concurrent'
          require_relative '../NetworkInterface/set-ip-routing'
          require_relative '../Scanner/active-hosts'
          require_relative '../Process/pkill'
        rescue LoadError => e
          puts "Error al incluir librerías: #{e.message}"
          exit(1)
        end
        @terminate = false
        @hostapd_success = false
        mutex = Mutex.new
        #condition = ConditionVariable.new
        
        #Initiating IPRouting
        WibrFake::IPRouting.new(ipaddr, iface).set

        #Run dnsmasq with Open3
        stdout_dnsmasq, stderr_dnsmasq, status_dnsmasq = Open3.capture3('dnsmasq -C dnsmask.conf')
        unless(status_dnsmasq.success?)
          if(stderr_dnsmasq.include?("already in use"))
            puts "dnsmasq process is already being used. Kill the process with the `pkill dnsmasq` command"
          else
            puts stderr_dnsmasq
          end
        end

        hostapd_thread = Thread.new do
          #Thread.current.report_on_exception = false
          hostapd_lift(mutex)
        end
         
        scan_hosts_thread = Thread.new do
          #Thread.current.report_on_exception = false
          WibrFake::Scanner.hosts(iface, range, mutex)
        #  prueba_scan(mutex)
        end

        hostapd_supervisor = Thread.new do
          #Thread.current.report_on_exception = false
          loop do
            sleep(1)
            #mutex.synchronize do
              unless @hostapd_success
                #safe_print(mutex, "hostapd no esta funcionando correctamente")
                @terminate = true
                #condition.signal
                break
              end
            #end
          end
        end

        Signal.trap("INT") do
          safe_print(mutex, "\nRecibida la senal de ctrl + c")
          mutes.synchronize { terminate = true }
        end

        loop do
          #safe_print(mutex, @terminate)
          #mutex.synchronize { break if @terminate }
          break if @terminate
          #puts scan_hosts_thread.alive?
          sleep(1)
        end
        [hostapd_thread, scan_hosts_thread, hostapd_supervisor].each(&:join)
      end

      def safe_print(mutex, message)
        mutex.synchronize { puts message }
      end

      def hostapd_lift(mutex)
        begin
          PTY.spawn('hostapd hostapd.conf') do |r, w, pid|
            r.each_line do |line|
              #mutex.synchronize do
                if line =~ /ENABLE/
                  @hostapd_success = true
                  #condition.signal
                elsif line =~ /DISABLED/
                  safe_print(mutex, "Fake access point was not launched correctly")
                  @hostapd_success = false
                  @terminate = true
                  #condition.signal
                  break
                elsif(line=~/already configured/)
                  safe_print(mutex, "hostapd process is already being used. Kill the process with the `pkill hostapd` command")
                  @hostapd_success = false
                  @terminate = true
                  #condition.signal
                  break
                #end
              end
            end
          rescue
          end 
        end
      end
    end
  end