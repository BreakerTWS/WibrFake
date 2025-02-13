require 'ipaddr'
require 'socket'

module WibrFake
    class IPAddr < IPAddr
        def initialize(ip = "172.168.1.1", mask = "255.255.255.0")
            super(ip)
            @mask = mask
        end

        def inspect
            "#<WibrFake IPAddr: #{self.ipv4? ? 'IPv4' : 'IPv6'}:#{self.to_s}/#{@mask}>"
        end

        def mask
            @mask
        end

        def defined_mask(mask)
            if mask =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
                @mask = mask
            else
                puts "Formato de mask erroneo"
            end
        end
        def succ(new_octet)
            parts = self.to_s.split('.')
            if parts.length == 4 && new_octet.to_i.between?(0, 255)
              parts[-1] = new_octet.to_s
              modified_ip = parts.join('.')
              return modified_ip
            else
              puts "Dirección IP o nuevo octeto no válidos."
              return nil
            end
        end
        def ip_range()
            range = []
            ip = self.to_s.strip.split('.')[0..2].join('.')
            ip_first = self.to_s.strip.split('.')[3].to_i
            ip_last = 254
            (ip_first..ip_last).each {|num|range<< "#{ip}.#{num}"}
            return range
        end 
        def mask_number()
            mask = self.to_i.to_s(2).count("1").to_s
        end
    end
end