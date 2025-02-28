begin
    require_relative 'dhcp'
    require_relative 'dns'
rescue LoadError => e
    puts e.message
    puts "load error for gem"
end
module WibrFake
    class Dnsmasq
        include DNS
        include DHCP
        def initialize(ipaddr, id, iface)
            begin
                require 'socket'
                require 'ipaddr'
            rescue LoadError
                puts e.message
            end
            @iface = iface
            @ipaddr = ipaddr 
            @ip = ipaddr.to_s
            @ip_vac = ipaddr.vac
            @dns_servers = [@ip].map { |ip| IPAddr.new(ip).hton.unpack('C4') }.flatten
            @subnet_mask = ipaddr.mask
            @broadcast_addr = ipaddr.succ("255")
            @domain_name = "local"
            @lease_time = 3600
            @id = id
            @dir_clients = File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'clients')
            Dir.mkdir(@dir_clients) unless(Dir.exists?(@dir_clients))
        end
    end
end