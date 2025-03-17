module WibrFake
    class Listing
        def self.sessions_list(id: nil)
            sessions = Array.new
            show_sessions = Array.new
            Dir.each_child(File.join(File.dirname(__FILE__), '..', 'Tmp')){|directory|
                if(Dir.exist?(File.join(File.dirname(__FILE__), '..', 'Tmp', directory)))
                    sessions << directory
                end
            }
            if(sessions.nil?)
                puts "Ninguna sesion de wibrfake esta activa"
            else
                puts cabecera = "\033[38;5;118mActivated sessions\e[1;37m".center(110)
                puts "-" * 100
                sessions.each_with_index{|session, index|
                    config_yml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'Tmp', session, 'config.yml'))
                    if(session==id)
                        show_sessions << {index: index+1, session: session, current: true, actived: config_yml['session']['session_save'], modified: config_yml['session']['session_modified']}
                    else
                        show_sessions << {index: index+1, session: session, current: false, actived: config_yml['session']['session_save'], modified: config_yml['session']['session_modified']}
                    end
                }
                show_sessions.each{|session|
                    actived = session[:actived]? "\033[38;5;46mActived\e[1;37m".ljust(28): "\033[38;5;196mNot actived\e[1;37m".ljust(28)
                    modified = session[:modified]? "\033[38;5;196mModified\e[1;37m".ljust(10):"\033[38;5;46mSaved\e[1;37m".ljust(10)
                    name = "\033[38;5;196m#{session[:current]? 'session >':''} \e[1;37m#{session[:session]}"
                    puts "#{name.ljust(71) +  ' '}  #{' ' * 10 + '|' + ' ' * 2 + actived +  ' ' }  #{' ' * 5 + '|' + ' ' * 2 + modified + ' ' * 6}"
                }
            end
            return sessions
        end
        def self.sessions_list_return
            sessions = Array.new
            Dir.each_child(File.join(File.dirname(__FILE__), '..', 'Tmp')){|directory|
                if(Dir.exist?(File.join(File.dirname(__FILE__), '..', 'Tmp', directory)))
                    sessions << directory
                end
            }
            if(sessions.nil?)
                puts "Ninguna sesion de wibrfake esta activa"
            else
                return sessions
            end
        end
    end
end