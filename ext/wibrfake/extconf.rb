require 'fileutils'

# Crear directorio necesario para RubyGems
FileUtils.mkdir_p(File.expand_path('..', __FILE__))

# Tu lógica de instalación
puts "🚀 Iniciando instalación de WibrFake..."
system('echo "Ejecutando scripts post-instalación..."')

# Crear archivo de configuración
config_path = File.expand_path('~/.wibrfake')
FileUtils.mkdir_p(config_path) unless Dir.exist?(config_path)

puts "✅ Configuración completada en: #{config_path}"