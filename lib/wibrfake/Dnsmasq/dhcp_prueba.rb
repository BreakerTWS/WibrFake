require 'socket'
require 'ipaddr'

# Configuración
server_ip = '192.168.1.1'
subnet_mask = '255.255.255.0'
broadcast_addr = '192.168.1.255'
lease_time = 3600  # 1 hora
dns_servers = ['192.168.1.1'].map { |ip| IPAddr.new(ip).hton.unpack('C4') }.flatten  # ¡DNS local!
domain_name = "local"
ip_pool = (2..254).cycle

socket = UDPSocket.new
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
socket.bind('0.0.0.0', 67)

puts "[+] Servidor DHCP escuchando en puerto 67..."

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
    index = 0

    while index < options.size
      tag = options[index].ord
      break if tag == 255

      if tag == 53
        len = options[index + 1].ord
        msg_type = options[index + 2].ord
        break
      end

      len = options[index + 1].ord rescue 0
      index += 2 + len
    end

    if msg_type == 1
      puts "DHCP Discover de #{mac}"
      offered_ip = "192.168.1.#{ip_pool.next}"
      leases[mac] = offered_ip

      # Construir DHCP Offer
      dhcp_options = [
        53, 1, 2,  # DHCP Offer
        54, 4, *IPAddr.new(server_ip).hton.unpack('C4'),  # Server IP
        51, 4, *[lease_time].pack('N').unpack('C4'),  # Lease Time
        1, 4, *IPAddr.new(subnet_mask).hton.unpack('C4'),  # Subnet Mask
        3, 4, *IPAddr.new(server_ip).hton.unpack('C4'),  # Gateway (Router)
        6, 4, *dns_servers,  # DNS Servers
        15, domain_name.bytes.size, *domain_name.bytes,  # Domain Name
        28, 4, *IPAddr.new(broadcast_addr).hton.unpack('C4'),  # Broadcast Address
        255  # End
      ].flatten.pack('C*').b

      response = [
        0x02.chr.force_encoding('BINARY'),  # Opcode: Boot Reply
        0x01.chr.force_encoding('BINARY'),  # Hardware Type: Ethernet
        0x06.chr.force_encoding('BINARY'),  # Hardware Address Length
        0x00.chr.force_encoding('BINARY'),  # Hops
        xid,  # Transaction ID
        [0].pack('n').b,  # Seconds Elapsed
        [0x8000].pack('n').b,  # Flags: Broadcast
        "\x00\x00\x00\x00".b,  # Client IP Address (0.0.0.0)
        IPAddr.new(offered_ip).hton.b,  # Your IP Address
        IPAddr.new(server_ip).hton.b,  # Server IP Address
        "\x00\x00\x00\x00".b,  # Gateway IP Address
        data[28..43].b,  # Client MAC Address
        ("\x00" * 64).b,  # Server Name
        ("\x00" * 128).b,  # Boot File Name
        "\x63\x82\x53\x63".b,  # Magic Cookie
        dhcp_options
      ].join

      socket.send(response, 0, broadcast_addr, 68)
      puts "Enviado DHCP Offer para #{offered_ip}"

    elsif msg_type == 3
      puts "DHCP Request de #{mac}"
      client_ip = leases[mac]

      if client_ip
        # Construir DHCP Ack
        dhcp_options = [
          53, 1, 5,  # DHCP Ack
          54, 4, *IPAddr.new(server_ip).hton.unpack('C4'),  # Server IP
          51, 4, *[lease_time].pack('N').unpack('C4'),  # Lease Time
          1, 4, *IPAddr.new(subnet_mask).hton.unpack('C4'),  # Subnet Mask
          3, 4, *IPAddr.new(server_ip).hton.unpack('C4'),  # Gateway (Router)
          6, 4, *dns_servers,  # DNS Servers
          15, domain_name.bytes.size, *domain_name.bytes,  # Domain Name
          28, 4, *IPAddr.new(broadcast_addr).hton.unpack('C4'),  # Broadcast Address
          255  # End
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
          IPAddr.new(client_ip).hton.b,
          IPAddr.new(server_ip).hton.b,
          "\x00\x00\x00\x00".b,
          data[28..43].b,
          ("\x00" * 64).b,
          ("\x00" * 128).b,
          "\x63\x82\x53\x63".b,
          dhcp_options
        ].join

        socket.send(response, 0, broadcast_addr, 68)
        puts "Enviado DHCP Ack para #{client_ip}"
      else
        puts "Cliente no reconocido: #{mac}"
      end
    end
  end
rescue Interrupt
  puts "\n[!] Servidor detenido"
  socket.close
end