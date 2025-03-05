module WibrFake
    class Listing
        def self.sessions_list(id: nil)
            sessions = Array.new
            Dir.each_child(File.join(File.dirname(__FILE__), '..', 'Tmp')){|directory|
                if(Dir.exists?(File.join(File.dirname(__FILE__), '..', 'Tmp', directory)))
                    sessions << directory
                end
            }
            if(sessions.empty?)
                puts "Ninguna sesion de wibrfake esta activa"
            else
                puts "Activated sessions:\n"
                sessions.each_with_index{|session, index|
                    if(session==id)
                        puts "\t#{index+1}: #{session} (current)"
                    else
                        puts "\t#{index+1}: #{session}"
                    end
                }
            end
            return sessions
        end
        def self.sessions_list_return
            sessions = Array.new
            Dir.each_child(File.join(File.dirname(__FILE__), '..', 'Tmp')){|directory|
                if(Dir.exists?(File.join(File.dirname(__FILE__), '..', 'Tmp', directory)))
                    sessions << directory
                end
            }
            if(sessions.empty?)
                puts "Ninguna sesion de wibrfake esta activa"
            else
                return sessions
            end
        end
    end
end