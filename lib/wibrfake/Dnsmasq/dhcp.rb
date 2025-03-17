module DHCP
    def dhcp
        socket = UDPSocket.new
        socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
        socket.bind('0.0.0.0', 67)
        leases = {}
        begin
            loop do
                data, client = socket.recvfrom(1024)
                next unless data[0].ord == 1
    
                mac = data[28..33].unpack('H2H2H2H2H2H2').join(':')
                xid = data[4..7].b
    
                # Parsear opciones DHCP
                options = data[240..-1].b
                msg_type = nil
                hostname = 'Desconocido'
                index = 0
    
                while index < options.size
                    tag = options[index].ord
                    break if tag == 255
    
                    if tag == 53
                        len = options[index + 1].ord
                        msg_type = options[index + 2].ord
                    elsif tag == 12  # Opción de Hostname
                        len = options[index + 1].ord
                        hostname = options[index + 2, len].to_s.force_encoding('UTF-8').scrub
                        hostname = 'Sin nombre' if hostname.empty?
                    end
    
                    len = options[index + 1].ord rescue 0
                    index += 2 + len
                end
    
                if msg_type == 1  # DHCP Discover
                    offered_ip = "#{@ip_vac}#{rand(2..254).to_s}"
                    leases[mac] = {
                        ip: offered_ip,
                        hostname: hostname
                    }
    
                    # Construir DHCP Offer
                    dhcp_options = [
                        53, 1, 2,  # DHCP Offer
                        54, 4, *IPAddr.new(@ip).hton.unpack('C4'),
                        51, 4, *[@lease_time].pack('N').unpack('C4'),
                        1, 4, *IPAddr.new(@subnet_mask).hton.unpack('C4'),
                        3, 4, *IPAddr.new(@ip).hton.unpack('C4'),
                        6, 4, *@dns_servers,
                        15, @domain_name.bytes.size, *@domain_name.bytes,
                        28, 4, *IPAddr.new(@broadcast_addr).hton.unpack('C4'),
                        255
                    ].flatten.pack('C*').b
    
                    response = [
                        0x02.chr.force_encoding('BINARY'),
                        0x01.chr.force_encoding('BINARY'),
                        0x06.chr.force_encoding('BINARY'),
                        0x00.chr.force_encoding('BINARY'),
                        xid,
                        [0].pack('n').b,
                        [0x8000].pack('n').b,
                        "\x00\x00\x00\x00".b,
                        IPAddr.new(offered_ip).hton.b,
                        IPAddr.new(@ip).hton.b,
                        "\x00\x00\x00\x00".b,
                        data[28..43].b,
                        ("\x00" * 64).b,
                        ("\x00" * 128).b,
                        "\x63\x82\x53\x63".b,
                        dhcp_options
                    ].join
    
                    socket.send(response, 0, @broadcast_addr, 68)
    
                elsif msg_type == 3  # DHCP Request
                    lease = leases[mac]
                    if lease
                        # Actualizar hostname si viene en el Request
                        lease[:hostname] = hostname unless hostname == 'unknow'
                        
                        # Construir DHCP Ack
                        dhcp_options = [
                            53, 1, 5,
                            54, 4, *IPAddr.new(@ip).hton.unpack('C4'),
                            51, 4, *[@lease_time].pack('N').unpack('C4'),
                            1, 4, *IPAddr.new(@subnet_mask).hton.unpack('C4'),
                            3, 4, *IPAddr.new(@ip).hton.unpack('C4'),
                            6, 4, *@dns_servers,
                            15, @domain_name.bytes.size, *@domain_name.bytes,
                            28, 4, *IPAddr.new(@broadcast_addr).hton.unpack('C4'),
                            255
                        ].flatten.pack('C*').b
    
                        response = [
                            0x02.chr.force_encoding('BINARY'),
                            0x01.chr.force_encoding('BINARY'),
                            0x06.chr.force_encoding('BINARY'),
                            0x00.chr.force_encoding('BINARY'),
                            xid,
                            [0].pack('n').b,
                            [0x8000].pack('n').b,
                            "\x00\x00\x00\x00".b,
                            IPAddr.new(lease[:ip]).hton.b,
                            IPAddr.new(@ip).hton.b,
                            "\x00\x00\x00\x00".b,
                            data[28..43].b,
                            ("\x00" * 64).b,
                            ("\x00" * 128).b,
                            "\x63\x82\x53\x63".b,
                            dhcp_options
                        ].join
    
                        socket.send(response, 0, @broadcast_addr, 68)
                        client_ip = lease[:ip]
                        
                        # Mostrar información del dispositivo
                        puts "\n\n\r\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m" ' ' + "Dispositive: \033[38;5;51m#{lease[:hostname]}\e[1;37m | " + "IP: \033[38;5;118m#{client_ip}\e[1;37m | " + "MAC: \033[38;5;214m#{mac}\e[1;37m" + ' ' + 'connected'
                        puts "\n"
                        print "\r\033[38;5;236m\e[0m\033[48;5;236m " + "\033[38;5;196mwibrfake  #{@iface} \e[0m" + "\033[38;5;236m\e[0m "
                        File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients.log'), 'a'){|file|
                            file.write "#{Time.now}, Hostname: #{lease[:hostname]}, IP: #{client_ip}, Mac: #{mac}, connect\n"
                        }
                        File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients_connected.log'), 'a'){|file|
                            file.write "#{lease[:hostname]}, #{client_ip}, #{mac}\n"
                            if(File.exist?(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients_disconnected.log')))
                                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', @id, 'clients', 'clients_disconnected.log'), 'r+'){|log|
                                    lines = log.readlines
                                    if lines.any? {|lin| lin.include?(mac)}
                                        lines.reject! { |linefile| linefile.include?(mac) }
                                    end
                                    log.rewind
                                    log.write(lines.join)
                                    log.truncate(log.pos)
                                }
                            end
                        }
                    end
                end
            end
        rescue Interrupt
            puts "\n[!] Servidor detenido"
            socket.close
        end
    end
end
