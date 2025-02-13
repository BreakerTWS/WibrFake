module WibrFake
    class Listing
        def self.apfake_show(configAP)
            puts "Set options for the access point:"
            puts
            puts " " * 2 + "#{'Name' + ' ' * 6} | #{' ' + 'Current Setting' + ' ' * 6} | #{'Required' + ' ' * 6} | #{'Description' + ' ' * 6}"
            puts " " * 2 + "----" + " " * 10 + "---------------"
            puts "  name" + " " * 10 + configAP.name.ljust(26) + "yes".ljust(3) +  " " * 12 + "Access point name"
            puts "  password" + " " * 6 + configAP.password.to_s.ljust(26) + configAP.required_pass.ljust(3) + " " * 12 + "Access Point Password"
            puts "  driver" + " " * 8 + configAP.driver.ljust(26) + "yes".ljust(3) + " " * 12 + "Specifies the network driver to be used"
            puts "  wp" + " " * 12 + configAP.wpa.to_s.ljust(26) + "no".ljust(3) + " " * 12 + "The type of wpa authentication"
            if(!configAP.password.nil?) and (configAP.wpa_wep.nil?)
                puts "  pairwise" + " " * 6 + configAP.wpa_pairwise.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "The encryption type used with WPA2" 
                puts "  key_mgmt" + " " * 6 + configAP.wpa_key_mgmt.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "Key management method"
                puts "  rekey" + " " * 9 + configAP.wpa_rekey.to_s.ljust(26) + "no".ljust(3) + " " * 12 + "Sets the interval for renewing the GTK"
            end
            puts "  gateway" + " " * 7 + configAP.ipaddr.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "Setting the router IP"
            puts "  mask" + " " * 10 + configAP.ipaddr.mask.ljust(26) + "yes".ljust(3) + " " * 12 + "Configure the netmask"
            puts "  channel" + " " * 7 + configAP.channel.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "Access Point Channel"
            puts "  hw_mode" + " " * 7 + configAP.hw_mode.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "The operating mode of the hardware"
            puts "  auth_algs" + " " * 5 + configAP.auth_algs.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "Allowed authentication algorithms"
            puts "  mww" + " " * 11 + configAP.wmm.to_s.ljust(26) + "yes".ljust(3) + " " * 12 + "Optimizes performance for multiple Wi-Fi connections"
            puts "  macaddr_acl" + " " * 3 + configAP.macaddr_acl.to_s.ljust(26) + "no".ljust(3) + " " * 12 + "Access denied for Mac addresses"
            puts "  ignore_ssid" + " " * 3 + configAP.ignore_ssid.ljust(26) + "no".ljust(3) + " " * 12 + "Ignore SSID for access point"
            puts "  server" + " " * 8 + configAP.server.ljust(26) + "yes".ljust(3) + " " * 12 +  "First server hosting link"
            puts "  server2" + " " * 7 + configAP.server2.ljust(26) + "yes".ljust(3) + " " * 12 + "Second Server Hosting Link"
        end
    end
end