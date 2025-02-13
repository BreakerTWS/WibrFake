require_relative 'ipaddr'
require_relative 'security_wpa'
module WibrFake
    class Config < SecurityWPA
        def initialize(configAP, iface)
            if(configAP.macaddr_acl=="yes")
                configAP.macaddr_acl = 0 
            else 
                configAP.macaddr_acl = 1
            end
            File.open('hostapd.conf', 'w'){|file|
                file.puts "interface=#{iface}"
                file.puts "driver=#{configAP.driver}"
                file.puts "ssid=#{configAP.name}"
                file.puts configAP.ignore_ssid=="enable"? "ignore_broadcast_ssid=0" : "ignore_broadcast_ssid=1"
                file.puts "hw_mode=#{configAP.hw_mode}"
                file.puts "channel=#{configAP.channel}"
                file.puts configAP.macaddr_acl=="enable"? "macaddr_acl=1":"macaddr_acl=0"
                file.puts configAP.ignore_ssid=="enable"? "ignore_broadcast_ssid=0":"ignore_broadcast_ssid=1"
                unless(configAP.password.nil?)
                    file.puts configAP.wpa=="wpa2"? "wpa=2": configAP.wpa=="wpa"? "wpa=1":"wpa=0"
                    file.puts configAP.wpa=="wpa2"? "wpa_passphrase=#{configAP.password}": configAP.wpa=="wpa"? "wpa_passphrase=#{configAP.password}":"wep_key0=#{configAP.password}\nwep_default_key=0"
                    file.puts "wpa_key_mgmt=#{configAP.wpa_key_mgmt}" if(configAP.wpa=="wpa2")
                    file.puts "wpa_pairwise=#{configAP.wpa_pairwise}" if(configAP.wpa=="wpa2")
                    file.puts "wpa_group_rekey=#{configAP.wpa_rekey}" if(!configAP.wpa_rekey.nil?)
                else
                    file.puts "wpa=0"
                end
                file.puts configAP.wpa=="wep"? "auth_algs=2":"auth_algs=1"
                file.puts configAP.wmm=="enable"? "wmm_enabled=1":"wmm_enabled=0"
            }

            File.open('dnsmask.conf', 'w'){|file|
                file.puts "interface=#{iface}"
                file.puts "dhcp-range=#{configAP.ipaddr.succ(1)},#{configAP.ipaddr.succ(253)},#{configAP.ipaddr.mask},12h"
                file.puts "server=#{configAP.server}"
                file.puts "server=#{configAP.server2}"
                file.puts "log-queries"
                file.puts "log-dhcp"
                file.puts "listen-address=#{configAP.loopback}"
                file.puts "address=/#/#{configAP.ipaddr.to_s}"
            }
        end

        def self.apfake(configAP)
            begin
                configAP.ipaddr = WibrFake::IPAddr.new("172.168.1.1", "255.255.255.0")
            rescue => e
                puts e.message
                exit(1)
            end
            configAP.name = "WibrFake Hacking"
            configAP.password = nil
            configAP.login = "basic"
            configAP.login_route = "login/"
            configAP.driver = "nl80211"
            configAP.channel = 6
            configAP.port = 3000
            configAP.hw_mode = "g"
            configAP.required_pass = "no"
            configAP.wpa = nil
            configAP.wpa_pairwise = "CCMP"
            configAP.wpa_key_mgmt = "WPA-PSK"
            configAP.wpa_rekey = nil
            configAP.ieee80211n = 1
            configAP.wmm = "enable"
            configAP.ignore_ssid = "enable"
            configAP.macaddr_acl = "disable"
            configAP.server = "8.8.8.8"
            configAP.server2 = "8.8.4.4"
            configAP.loopback = "127.0.0.1"
            configAP.host_server = "0.0.0.0"
            configAP.path_credential = nil
            return configAP
        end
    end
end