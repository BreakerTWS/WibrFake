require 'fileutils'

# Método para demonizar un proceso
def run_daemon(name, log_file, pid_file)
   fork do
    # Cambiar el directorio de trabajo (opcional)
 #   Dir.chdir("/")

    # Redirigir la salida estándar y de error a un archivo
#    File.open(log_file, "a") do |f|
#      $stdout.reopen(f)
#      $stderr.reopen(f)
#    end

    # Guardar el PID en el archivo especificado
    File.open(pid_file, 'w') do |file|
      file.puts Process.pid
    end

    # Aquí va el código que quieres que ejecute el demonio
    loop do
      puts "#{name} está corriendo..."
      sleep 5
    end
  end

  #pid # Devolver el PID del proceso demonio
end

# Archivos de log y PID
log_file1 = "daemon1.log"
pid_file1 = "daemon1.pid"

log_file2 = "daemon2.log"
pid_file2 = "daemon2.pid"

# Demonizar el primer proceso
run_daemon("Demonio 1", log_file1, pid_file1)

# Demonizar el segundo proceso
run_daemon("Demonio 2", log_file2, pid_file2)

# Mantener el script en ejecución para que los demonios sigan corriendo
#sleep
