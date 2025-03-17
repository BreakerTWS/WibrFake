module DNS
    def dns
        socket = UDPSocket.new
        socket.bind('0.0.0.0', 53)

        #puts "[+] DNS Server listening on port 53..."

        begin
            loop do
                data, client = socket.recvfrom(1024)
                #"Consulta DNS de #{client[3]}"
                transaction_id = data[0..1]
                flags = "\x85\x80".b  # QR=1 (Respuesta), AA=1 (Autoritativo), RD=1, RA=1
                questions = data[4..5]
                answer_rrs = "\x00\x01".b  # 1 respuesta
                authority_rrs = "\x00\x00".b
                additional_rrs = "\x00\x00".b
                query = data[12..-1]
                answer = "\xc0\x0c".b +  # Nombre comprimido (apunta a la consulta)
                "\x00\x01".b +  # Tipo A
                "\x00\x01".b +  # Clase IN
                [300].pack('N') +  # TTL (5 minutos)
                "\x00\x04".b +  # Longitud de la IP (4 bytes)
                IPAddr.new(@ip).hton  # IP del servidor

                response = [transaction_id, flags, questions, answer_rrs, authority_rrs, additional_rrs, query, answer].join
                socket.send(response, 0, client[3], client[1])
            end
        rescue Interrupt
            #puts "\n[!] Servidor DNS detenido"
            socket.close
        end
    end
end