module WibrFake
    class RailsLogin
        def self.validate?(login)
            ["basic", "wifietecsa"].each{|log_in|
                if(log_in==login)
                    return true
                end
            }
            return false
        end
        
        def self.show(verb = 0)
            return ["basic", "wifietecsa"] if verb==0
            puts ["basic", "wifietecsa"]
        end
    end
end