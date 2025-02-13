#require 'socket'
#require 'webrick'
require_relative "../config/application"

# Initialize the Rails application.
Rails.application.initialize!

#require_relative '../config/environment'
require 'packetfu'
#require_relative '../config/environment'
=begin
port = 5678
host = "0.0.0.0"
server = WEBrick::HTTPServer.new(Port: port, BindAddress: host)

server.mount '/', Rack::Builder.new {
  use Rack::CommonLogger
  use Rack::ShowException
  run Rails.application
}
server.start
=begin
begin
  app = Rails.application
  server = TCPServer.new(5678)

  puts "Servidor iniciado en http://localhost:5678"

  loop do
    session = server.accept

    begin
      request = session.gets
      puts request

      if request.nil?
        session.print "HTTP/1.1 400 Bad Request\r\n"
        session.print "Content-Type: text/plain\r\n"
        session.print "Content-Length: 15\r\n"
        session.print "\r\n"
        session.print "Bad Request"
        next
      end

      method, full_path = request.split(' ')
      path, query = full_path.split('?')

      # Leer las cabeceras
      headers = {}
      while (header = session.gets) && header != "\r\n"
        key, value = header.split(': ', 2)
        headers[key] = value.chomp if value
      end

      # Crear un objeto de entrada vacío
      input = StringIO.new
      input.set_encoding 'UTF-8'  # Cambiado a UTF-8

      # Llamar a la aplicación Rails
      status, headers, body = app.call({
        'REQUEST_METHOD' => method,
        'PATH_INFO' => path,
        'QUERY_STRING' => query || '',
        'SERVER_NAME' => 'localhost',
        'SERVER_PORT' => '5678',
        'rack.version' => [1, 3],
        'rack.input' => input,
        'rack.errors' => $stderr,
        'rack.multithread' => false,
        'rack.multiprocess' => false,
        'rack.run_once' => false,
        'rack.url_scheme' => 'http'
      })

      # Enviar la respuesta al cliente
      session.print "HTTP/1.1 #{status}\r\n"
      headers.each do |key, value|
        session.print "#{key}: #{value}\r\n"
      end
      session.print "\r\n"
      body.each { |part| session.print part }
    rescue StandardError => e
      puts "Error procesando la solicitud: #{e.message}"
      session.print "HTTP/1.1 500 Internal Server Error\r\n"
      session.print "Content-Type: text/plain\r\n"
      session.print "Content-Length: 21\r\n"
      session.print "\r\n"
      session.print "Internal Server Error"
    rescue Errno::EPIPE
    ensure
      session.close
    end
  end
rescue Interrupt
  puts "\nServidor detenido."
ensure
  server.close if server
end
=end
