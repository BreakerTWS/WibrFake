require 'open3'

def mostrar_interfaces
  # Obtener la lista de interfaces de red
  interfaces_output, interfaces_error, interfaces_status = Open3.capture3('iw dev')

  if interfaces_status.success?
    interfaces = []
    interfaces_output.each_line do |line|
      if line =~ /^\s*Interface\s+(\S+)/
        interfaces << $1
      end
    end

    # Mostrar las interfaces encontradas
    if interfaces.empty?
      puts "No se encontraron interfaces de red."
    else
      puts "Interfaces de red encontradas:"
      interfaces.each { |interface| puts "  * #{interface}" }
    end
  else
    puts "Error al ejecutar 'iw dev': #{interfaces_error.strip}"
  end
end

mostrar_interfaces
