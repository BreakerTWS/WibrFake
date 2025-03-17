module WibrFake
    class Help
        def self.help
            puts "\n" + "=" * 70
            puts " " * 20 + "COMMAND REFERENCE"
            puts "=" * 70
            puts "\n"

            basic_commands = {
                "  help" => "Display this help panel",
                "  set" => "Configure access point parameters",
                "  clear" => "Clear the terminal screen",
                "  exit" => "Exit the program",
                "  banner" => "Redisplay the banner"
            }

            show_commands = {
                "  options" => "Show current configuration options and their status",
                "  process" => "List running processes",
                "  login" => "View available login templates"
            }

            session_commands = {
                "  list" => "List all sessions",
                "  new" => "Create new session",
                "  rename" => "Rename existing session",
                "  remove" => "Delete session",
                "  save" => "Save current session",
                "  activate" => "Mark session as persistent",
                "  init" => "Load saved session"
            }

            monitor_commands = {
                "  on" => "Enable monitor mode",
                "  off" => "Disable monitor mode",
                "  status" => "Check monitor status"
            }

            client_commands = {
                "  connected" => "Show connected devices",
                "  disconnected" => "List disconnected devices",
                "  logs" => "View connection history"
            }

            mac_commands = {
                "  show" => "Display current MAC address",
                "  set [MAC]" => "Set custom MAC address",
                "  ramset" => "Generate random MAC address",
                "        └ [OUI]" => "Use specific OUI prefix",
                "  list" => "Browse valid OUI prefixes",
                "  reset" => "Restore original MAC address"
            }

            apfake_commands = {
                "  show" => "View AP configuration",
                "  on" => "Enable rogue AP mode",
                "  off" => "Disable rogue AP mode",
                "  status" => "Check AP status"
            }
            
            clients_commands = {
                "  connected" => "list of currently connected clients",
                "  disconnected" => "recently disconnected clients",
                "  logs" => "full interaction history with access point"
              }

            webserver_commands = {
                "  show" => "Display server settings",
                "  on" => "Start web server",
                "  off" => "Stop web server",
                "  status" => "Check server status"
            }

            # Formatting
            puts "Basic Commands".ljust(30) + "Description"
            puts "-" * 70
            basic_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "-" * 70
            puts "show [option]"
            show_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "=" * 70
            puts "\nCore Commands:"
            puts "-" * 70
            puts "monitor [option]"
            monitor_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "-" * 70
            puts "apfake [option]"
            apfake_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "-" * 70
            puts "clients [option]"
            clients_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }

            puts "\n" + "-" * 70
            puts "web_server [option]"
            webserver_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "-" * 70
            puts "mac [option]"
            mac_commands.each { |cmd, desc| puts "#{cmd.ljust(30)} - #{desc}" }
            
            puts "\n" + "=" * 70
        end
    end
end