class String
    #Puts text string
    def puts_white(input, show = 0)
        return "\e[1;37m#{input}\e[0m" if show == 0
        puts "\e[1;37m#{input}\e[0m"
    end

    def puts_black(input, show = 0)
        return "\e[0m\033[38;5;236m#{input}\e[0m" if show == 0
        puts "\e[0m\033[38;5;236m#{input}\e[0m"
    end

    def puts_red(input, show = 0)
        return "\033[38;5;196m#{input}\e[0m" if show == 0
        puts "\033[38;5;196m#{input}\e[0m"
    end

    def puts_green(input, show = 0)
        return "\033[38;5;46m#{input}\e[0m" if show == 0
        puts "\033[38;5;46m#{input}\e[0m"
    end

    def puts_yellow(input, show = 0)
        return "\e[1;33m#{input}\e[0m" if show == 0
        puts "\e[1;33m#{input}\e[0m"
    end

    def puts_blue(input, show = 0)
        return "\e[1;34m#{input}\e[0m" if show == 0
        puts "\e[1;34m#{input}\e[0m"
    end

    def puts_blue_suave(input, show = 0)
        return "\e[1;36m#{input}\e[0m" if show == 0
        puts "\e[1;36m#{input}\e[0m"
    end

    def puts_morado(input, show = 0)
        return "\e[1;35m#{input}\e[0m" if show == 0
        puts "\e[1;35m#{input}\e[0m"
    end

    #Print text string
    def print_white(input, show = 0)
        return "\e[1;37m#{input}\e[0m" if show == 0
        print "\e[1;37m#{input}\e[0m"
    end

    def print_red(input, show = 0)
        return "\033[38;5;196m#{input}\e[0m" if show == 0
        print "\033[38;5;196m#{input}\e[0m"
    end

    def print_green(input, show = 0)
        return "\033[38;5;46m#{input}\e[0m" if show == 0
        print "\033[38;5;46m#{input}\e[0m"
    end

    def print_yellow(input, show = 0)
        return "\e[1;33m#{input}\e[0m" if show == 0
        print "\e[1;33m#{input}\e[0m"
    end

    def print_blue(input, show = 0)
        return "\e[1;34m#{input}\e[0m" if show == 0
        print "\e[1;34m#{input}\e[0m"
    end

    def print_blue_suave(input, show = 0)
        return "\e[1;36m#{input}\e[0m" if show == 0
        print "\e[1;36m#{input}\e[0m"
    end

    def print_morado(input, show = 0)
        return "\e[1;35m#{input}\e[0m" if show == 0
        print "\e[1;35m#{input}\e[0m"
    end

    def br_colorize(input)
        for i in input.chars
            if i == "░"
                i = "\033[38;5;196m#{i}\e[0m"
            elsif i == "▒"
                i = "\033[38;5;124m#{i}\e[0m"
            elsif i == "▓"
                i = "\033[38;5;124m#{i}\e[0m"
            else
                i = "\033[38;5;236m#{i}\e[0m"
            end
            print i
        end
    end

    #Define animations
    def puts_spin(input)
        spin = %w[\\ | / -]
        count = 0
        while true
            if count <= 20
                spin.each {|line|
                    print " #{input} [#{line}]\r"
                    sleep(0.13)
                    count += 1
                }
                break if count >= 19
            end
        end
    end
end
