module WibrFake
    class SecurityWPA
        def self.scan_mgmt(wpa, mgmt)
            #config wpa security
            wpa1_key_mgmt = %w[WPA-PSK WPA-EAP WPA-PSK-SHA1 KEY_MGMT_802_1X]
            wpa2_key_mgmt = wpa1_key_mgmt + %w[WPA-PSK-SHA256 WPA-EAP-SHA256 WPA-EAP-GCT WPA-EAP-FAST WPA-EAP-TTLS WPA-EAP-PEAP WPA-EAP-PSK]
            wpa3_key_mgmt = %w[SAE]
            if(wpa=="wpa")
                unless(wpa1_key_mgmt.include?(mgmt))
                   puts "Clave #{mgmt} no es valido para #{wpa}"
                    return 1
                end
            elsif(wpa=="wpa2")
                unless(wpa2_key_mgmt.include?(mgmt))
                    puts "Clave #{mgmt} no es valido para #{wpa}"
                    return 1
                end
            elsif(wpa=="wpa3")
                unless(wpa3_key_mgmt.include?(mgmt))
                    puts "Clave #{mgmt} no es valido para #{wpa}"
                    return 1
                end
            end
            return 0
        end
        def self.scan_pairwise(wpa, pairwise)
            wpa12_pairwise = %w[TKIP CCMP]
            wpa3_pairwise = %w[GCMP]
            if(wpa=="wpa") or (wpa=="wpa2")
                unless(wpa12_pairwise.include?(pairwise))
                    puts "Cifrado #{pairwise} no es compatible o no existe para #{wpa}"
                    return 1
                end
            elsif(wpa=="wpa3")
                unless(wpa3_pairwise.include?(pairwise))
                    puts "Cifrado #{pairwise} no es compatible o no existe para #{wpa}"
                    return 1
                end
            end
            return 0
        end
    end
end