module WibrFake
    class Listing
        def self.web_server_show(configAP)
            puts "Establecer opciones para el servidor:"
            puts
            puts " " * 2 + "#{'Name' + ' ' * 6} | #{' ' + 'Current Setting' + ' ' * 6} | #{'Required' + ' ' * 6} | #{'Description' + ' ' * 6}"
            puts " " * 2 + "----" + " " * 10 + "---------------"
            puts "  login" + " " * 9 + configAP.login.to_s.ljust(26) + "yes".ljust(3) +  " " * 12 + "Login to be used by the web server"
            puts "  route" + " " * 9 + configAP.login_route.to_s.ljust(26) + "yes".ljust(3) +  " " * 12 + "Ruta de la pagina del servidor web"
            puts "  host" + " " * 10 + configAP.host_server.ljust(26) + "yes".ljust(3) +  " " * 12 + "Hosting to be used by the web server"
            puts "  port" + " " * 10 + configAP.port.to_s.ljust(26) + "yes".ljust(3) +  " " * 12 + "Port to be used by the web server"
            puts "  credentials" + " " * 4 + configAP.path_credential.to_s.ljust(26) + "no".ljust(3) +  " " * 12 + "Path where credentials will be saved"
            puts "-" * 70
            puts "Link: http://#{configAP.host_server}:#{configAP.port.to_s}/#{configAP.login_route.to_s}"
        end
    end
end