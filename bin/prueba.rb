require 'open3'
stdout_dnsmasq, stderr_dnsmasq, status_dnsmasq = Open3.capture3('dnsmasq -C dnsmask.conf')
        unless(status_dnsmasq.success?)
          if(stderr_dnsmasq.include?("already in use"))
            puts "dnsmasq process is already being used. Kill the process with the `pkill dnsmasq` command"
          else
            puts stderr_dnsmasq
          end
        end
