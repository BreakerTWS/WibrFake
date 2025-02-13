require 'packetfu'

# Configura la interfaz de red
iface = 'wlo1'  # Cambia esto a tu interfaz deseada
capture = PacketFu::Capture.new(:iface => iface, :start => true)

# Almacena las direcciones IP y MAC
devices = {}

# Captura paquetes
capture.stream.each do |p|
  packet = PacketFu::Packet.parse(p)

  # Verifica si el paquete es ARP
  if packet.is_arp?
    # Obtiene la dirección IP y MAC
    ip = packet.arp_src_ip.value  # Cambiado a .value
    mac = packet.arp_src_mac.to_s  # Cambiado a .to_s

    # Almacena en el hash si no está ya presente
    devices[ip] ||= mac

    # Imprime la dirección IP y MAC
    puts "IP: #{ip}, MAC: #{mac}"
  end

  # Salir después de capturar un número específico de paquetes
  break if devices.size >= 10  # Cambia el número según sea necesario
end
