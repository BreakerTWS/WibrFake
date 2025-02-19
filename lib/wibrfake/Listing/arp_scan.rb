module WibrFake
    class Listing
        def self.arp_scan_show(configAP)
            puts "Set options for the scanner arp hosts:"
            puts
            puts " " * 2 + "#{'Name' + ' ' * 6} | #{' ' + 'Current Setting' + ' ' * 6} | #{'Required' + ' ' * 6} | #{'Description' + ' ' * 6}"
            puts " " * 2 + "----" + " " * 10 + "---------------"
            puts "  host" + " " * 10 + configAP.host_scan_arp.to_s.ljust(26) + "yes".ljust(3) +  " " * 12 + "Host para el escaneo arp"
            puts "  host_init" + " " * 5 + configAP.host_init_scan_arp.to_s.ljust(26) + "no".ljust(3) +  " " * 12 + "Host inicial donde comenzara el escaneo arp"
            puts "  host_last" + " " * 5 + configAP.host_last_scan_arp.to_s.ljust(26) + "no".ljust(3) +  " " * 12 + "Host final donde terminara el escaneo arp"
        end
    end
end