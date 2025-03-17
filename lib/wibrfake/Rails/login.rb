module WibrFake
    class RailsLogin
        def self.logins
            return ['basic', 'nauta_etecsa', 'nauta_hogar', 'facebook', 'instagram', 'google']
        end
        def self.validate?(login)
            logins.each{|log_in|
                if(log_in==login)
                    return true
                end
            }
            return false
        end
        
        def self.show(verb = 0)
            return logins if verb==0
            puts logins
        end
    end
end