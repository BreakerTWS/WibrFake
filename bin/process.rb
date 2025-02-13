def find_pid_by_name(process_name)
  pids = []
  # Iterar sobre los directorios en /proc (cada PID es un directorio numérico)
  Dir.entries('/proc').each do |entry|
    next unless entry =~ /^\d+$/ # Solo directorios numéricos (PIDs)

    # Leer el nombre del proceso desde /proc/[PID]/comm
    comm_path = File.join('/proc', entry, 'comm')
    begin
      cmdline = File.read(comm_path).strip
      if cmdline.include?(process_name)
        pids << entry.to_i
      end
    rescue Errno::ENOENT, Errno::EACCES
      # El proceso puede haber terminado o no hay permisos para acceder
      next
    end
  end
  pids
end

# Llamar al método para encontrar el PID de dnsmasq
dnsmasq_pids = find_pid_by_name("dnsmasq")
puts "PIDs de dnsmasq: #{dnsmasq_pids.join(', ')}"
