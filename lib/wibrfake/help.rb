module WibrFake
    class Help
        def self.help
            puts "\n" + "=" * 70
            puts " " * 20 + "HELP ME"
            puts "=" * 70
            puts "\n"

            comandos_basicos = {
                "  help" => "Show the Help Panel",
                "  clear" => "Clean the screen",
                "  exit" => "Exit the program",
                "  banner" => "Change the banner",
            }

            comandos_show = {
                "  apfake" => "Show access point options",
                "  server" => "Show web server options",
                "  process" => "Show runner process",
                "  login" => "Show available logins",
            }
            comandos_apfake = {
                "  set" => "Map data",
                "  run" => "Run Access Point",
                "     └ server" => "Run server"
            }

            comandos_monitor = {
                "  on" => "Activate monitor mode",
                "  off" => "Desactivate monitor mode",
                "  status" => "Monitor mode status",
            }

            comandos_mac = {
                "  show" => "Show current mac",
                "  set [MAC]" => "Change mac",
                "  ramset" => "Change mac to random",
                "        └ [OUI]" => "Change mac random using an OUI",
                "  list" => "List of OUIs you can use",
                "  reset" => "Reset your Mac permanently",
            }

            # Formato de encabezado
            puts "Basics Commands".ljust(30) + "Description"
            puts "-" * 70

            comandos_basicos.each do |comando, descripcion|
                puts "#{comando.ljust(30)} - #{descripcion}"
            end
            puts "-" * 70
            puts "show [option]"
            comandos_show.each do |comando, descripcion|
                puts "#{comando.ljust(30)} - #{descripcion}"
            end
            puts "\n" + "=" * 70 + "\n\n\n"
            puts "Wibrfake commands:"
            puts "-" * 70

            comandos_apfake.each do |comando, descripcion|
                puts "#{comando.ljust(30)} - #{descripcion}"
            end 

            puts "-" * 70
            puts "monitor [option]"
            comandos_monitor.each do |comando, descripcion|
                puts "#{comando.ljust(30)} - #{descripcion}"
            end

            puts "-" * 70
            puts "mac [option]"
            comandos_mac.each do |comando, descripcion|
                puts "#{comando.ljust(30)} - #{descripcion}"
            end
            puts "\n" + "=" * 70
        end
    end
end