require 'readline'

trap('INT', 'SIG_IGN')
commands = %w[help clear banner exit]

completion = proc{|line| commands.grep(/^#{Regexp.escape(line)}/)}

Readline.completion_proc = completion
Readline.completion_append_character = ' '
while line = Readline.readline("\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  \e[0m\033[38;5;236m\e[0m ", true)
	puts line unless line.nil? or line.squeeze.empty?
	break if line =~ /^quit.*/i or line =~ /^exit.*/i
end
