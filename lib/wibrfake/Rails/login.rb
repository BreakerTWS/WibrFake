module WibrFake
    class RailsLogin
        def self.validate?(login)
            return show.include?(login)? true:false
        end
        
        def self.show(verb = 0)
            String.new.puts_white(["basic", "wifietecsa"], verb)
        end
    end
end