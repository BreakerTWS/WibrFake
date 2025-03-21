require_relative '../NetworkInterface/monitor'
require_relative '../Process/processes'
module WibrFake
    class Listing
        def self.show_process(iface)
            puts " " * 2 + "#{'Name' + ' ' * 20} | #{' ' + 'status' + ' ' * 20} | #{'Description' + ' ' * 6}"
            puts " " * 2 + "----" + " " * 23 + "---------------" + " " * 13 + "---------------"
            puts
            puts "  monitor" + " " * 21 + WibrFake::Monitor.status(iface, 1).ljust(3) +  " " * 26 + "Status of mode monitor"
            puts "  web_server" + " " * 18 + WibrFake::Processes.status("server", 1).ljust(3) +  " " * 26 + "Status of web server"
            puts "  apfake" + " " * 22 + WibrFake::Processes.status("hostapd", 1).ljust(3) +  " " * 26 + "Status of the point access"
        end
    end
end