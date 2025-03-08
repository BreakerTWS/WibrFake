require_relative 'ipaddr'
require_relative 'security_wpa'
module WibrFake
    class Config < SecurityWPA
        def initialize(configAP, iface, id)
            #if(configAP.macaddr_acl=="yes")
            #    configAP.macaddr_acl = 0 
            #else 
            #    configAP.macaddr_acl = 1
            #end
            tmp_id = File.join(File.dirname(__FILE__), '..', 'Tmp', id)
            unless(Dir.exists?(File.join(tmp_id, 'hostapd')))
                Dir.mkdir(File.join(tmp_id, 'hostapd'))
            end
            unless(Dir.exists?(File.join(tmp_id, 'wkdump')))
                Dir.mkdir(File.join(tmp_id, 'wkdump'))
            end
            unless(Dir.exists?(File.join(tmp_id, 'credentials')))
                Dir.mkdir(File.join(tmp_id, 'credentials'))
            end
            File.open(File.join(tmp_id, 'hostapd', 'hostapd.conf'), 'w'){|file|
                file.puts "interface=#{iface}"
                file.puts "driver=#{configAP.driver}"
                file.puts "ssid=#{configAP.ssid}"
                file.puts configAP.ignore_ssid=="enable"? "ignore_broadcast_ssid=0" : "ignore_broadcast_ssid=1"
                file.puts "hw_mode=#{configAP.hw_mode}"
                file.puts "channel=#{configAP.channel}"
                #file.puts configAP.macaddr_acl=="enable"? "macaddr_acl=1":"macaddr_acl=0"
                unless(configAP.wpa.nil?)
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

            File.open(File.join(tmp_id, 'wkdump', "#{id}.wkdump"), 'w'){|file|
                file.puts "set iface #{iface}"
                file.puts "set driver #{configAP.driver}"
                file.puts "set ssid #{configAP.ssid}"
                file.puts configAP.ignore_ssid=="enable"? "set ignore_ssid enable" : "set ignore_ssid disable"
                file.puts "set hw_mode #{configAP.hw_mode}"
                file.puts "set channel #{configAP.channel}"
                #file.puts configAP.macaddr_acl=="enable"? "set macaddr_acl enable" : "set macaddr_acl disable"
                unless(configAP.wpa.nil?)
                    file.puts configAP.wpa=="wpa2"? "set wp wpa2": configAP.wpa=="wpa"? "set wp wpa" : "set wp wep"
                    file.puts "set password #{configAP.password}"
                    file.puts "set key_mgmt #{configAP.wpa_key_mgmt}" if(configAP.wpa=="wpa2")
                    file.puts "set pairwise #{configAP.wpa_pairwise}" if(configAP.wpa=="wpa2")
                    file.puts "set rekey #{configAP.wpa_rekey}" if(!configAP.wpa_rekey.nil?)
                else
                    file.puts "set wp nil"
                end
                file.puts configAP.wmm=="enable"? "set wmm enable" : "set wmm disable"
                file.puts "set login #{configAP.login}"
                file.puts "set route #{configAP.login_route}"
                file.puts "set port #{configAP.port}"
            }
        end

        def self.apfake(configAP)
            begin
                configAP.ipaddr = WibrFake::IPAddr.new("172.168.1.1", "255.255.255.0")
            rescue => e
                puts e.message
                exit(1)
            end
            configAP.ssid = "WibrFake Hacking"
            configAP.password = nil
            configAP.login = "basic"
            configAP.login_route = "login/"
            configAP.driver = "nl80211"
            configAP.channel = 6
            configAP.port = 3000
            configAP.hw_mode = "g"
            configAP.wpa = nil
            configAP.wpa_pairwise = "CCMP"
            configAP.wpa_key_mgmt = "WPA-PSK"
            configAP.wpa_rekey = nil
            configAP.ieee80211n = 1
            configAP.wmm = "enable"
            configAP.ignore_ssid = "enable"
            configAP.macaddr_acl = "disable"
            configAP.loopback = "127.0.0.1"
            configAP.host_server = "0.0.0.0"
            configAP.file_wkdump = nil
            configAP.path_credential = nil
            configAP.session_remove = true
            configAP.session_modified = true
            return configAP
        end
    end
end