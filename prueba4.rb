require 'colorize'
require 'tty-prompt'

prompt = TTY::Prompt.new
commands = %w[help clear banner exit]

loop do
  input = prompt.ask("wibrfake > ".cyan) do |q|
    q.required true
    # No se establece un bloque de validación, así que no habrá mensaje de error
  end

  break if input =~ /^quit.*/i || input =~ /^exit.*/i

  unless input.empty?
    if commands.include?(input)
      puts "Has ingresado: #{input}"
    else
      # Aquí puedes manejar la entrada no válida sin mostrar un mensaje
      puts "Comando no válido. Intenta de nuevo." unless input.empty?
    end
  end
end
