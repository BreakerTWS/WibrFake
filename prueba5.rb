require_relative 'lib/wibrfake/tty/prompt'

prompt = TTY::Prompt.new
commands = %w[help clear banner exit]

# Inicializar el color del prompt en verde
prompt_color_valid = "\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m"  # Verde
prompt_color_invalid = "\033[38;5;236m\e[0m\033[48;5;236m\033[38;5;196m✘ wibrfake  wlo1 \e[0m\033[38;5;196m\e[0m"  # Rojo

loop do
  # Mostrar el prompt con el color actual
  input = prompt.ask(prompt_color_valid) do |q|
    q.required true
  end

  break if input =~ /^quit.*/i || input =~ /^exit.*/i

  unless input.empty?
    if commands.include?(input)
      puts "Has ingresado: #{input}"
      # Si el comando es válido, mantener el color del prompt a verde
      prompt_color_valid = "\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m"  # Mantener el color verde
    else
      # Si el comando es inválido, mostrar un mensaje de error y cambiar el color del prompt a rojo
      puts "\e[31mComando no válido. Intenta de nuevo.\e[0m"  # Mensaje de error en rojo
      prompt_color_valid = prompt_color_invalid  # Cambiar el color del prompt a rojo
    end
  end
end
