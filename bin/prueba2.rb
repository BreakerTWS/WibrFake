require 'packetfu'
require 'set'
require 'thread'

# Rango de IPs a escanear
ip_range = (1..254).map { |ip| "172.168.1.#{ip}" }

# Conjunto para almacenar hosts activos
active_hosts = Set.new

# Mutex para sincronizar el acceso a active_hosts
mutex = Mutex.new

# Número de hilos a utilizar
num_threads = 50  # Ajusta este número según la capacidad de tu sistema

loop do
  threads = []
  ip_range.each_slice(num_threads) do |ip_batch|  # Procesar en lotes
    ip_batch.each do |ip|
      threads << Thread.new do
        begin
          mac = PacketFu::Utils.arp(ip, iface: "wlo1", timeout: 0.05)  # Reducir el tiempo de espera
          mutex.synchronize do
            if mac
              unless active_hosts.include?(ip)  # Si el host no estaba activo antes
                puts "#{ip} => Host activo: #{mac.to_s}"
                active_hosts.add(ip)  # Agregar a la lista de hosts activos
              end
            else
              if active_hosts.include?(ip)  # Si el host estaba activo pero ahora no responde
                puts "#{ip} => Host desactivado"
                active_hosts.delete(ip)  # Eliminar de la lista de hosts activos
              end
            end
          end
        rescue => e
          #mutex.synchronize do
          #  puts "#{ip} => Error: #{e.message}"
          #end
        end
      end
    end
    threads.each(&:join)  # Esperar a que todos los hilos de este lote terminen
  end

  #sleep(2)  # Esperar 2 segundos antes del próximo escaneo (ajusta según sea necesario)
end
