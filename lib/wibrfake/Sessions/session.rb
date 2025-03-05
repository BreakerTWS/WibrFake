module WibrFake
    class Session
        def initialize(id: nil)
            begin
                require_relative '../Listing/sessions'
                require_relative '../Config/ipaddr.rb'

                @id = id
                Dir.mkdir(File.join(File.dirname(__FILE__), '..', 'Tmp', @id))
                config_session = {
                    'WibrFake' => 'Config',
                    'session' => {
                        'session_save' => false,
                        'session_modified' => false,
                        'name' => id
                    }
                }
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'config.yml'), 'w'){|file|
                    file.write(config_session.to_yaml)
                }
            rescue LoadError => e
                puts e.message
            rescue Errno::EINVAL
            end
        end
        
        def rename(number: nil, name: nil, id: nil)
            sessions = WibrFake::Listing.sessions_list_return
            status = false
            verify_session = false
            if(sessions.empty?)
                warn "No hay sesiones activas"
            else
                sessions.each_with_index{|session, index|
                    index += 1
                    if(index==number.to_i)
                        begin
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', session), File.join(File.dirname(__FILE__), '..', 'Tmp', name))
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{session}.wkdump"), File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{name}.wkdump"))
                        rescue Errno::EINVAL
                            warn "[-] Nombre definida para esta sesion ya existe"
                        end
                        verify_session = "current" if (session==id)
                        status = true
                    elsif(session==number)
                        begin
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', session), File.join(File.dirname(__FILE__), '..', 'Tmp', name))
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{session}.wkdump"), File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{name}.wkdump"))
                        rescue Errno::EINVAL
                            warn "[-] Nombre definida para esta sesion ya existe"
                        end
                        verify_session = "current" if (session==id)
                        status = true
                    end
                }
                if(status)
                    if(verify_session=='current')
                        return verify_session
                    else
                        return name
                    end
                else
                    warn "index o nombre de sesion no encontrada"
                    return status
                end
            end
        end
        def remove(number: nil)
            sessions = WibrFake::Listing.sessions_list_return
            if(sessions.empty?)
                warn "Sesion definida no existe"
            else
                sessions.each_with_index{|session, index|
                    index += 1
                    if(index==number.to_i)
                        FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'Tmp', session))
                    end
                }
            end
        end
        def save(id: nil)
            if(id.nil?)
                puts
            else
                config_session = {
                    'WibrFake' => 'Config',
                    'session' => {
                        'session_save' => true,
                        'session_modified' => false,
                    }
                }
                File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'config.yml'), 'w'){|file|
                    file.write(config_session.to_yaml)
                }
            end
        end
        def init(number: nil)
            status = false
            workspace = String.new
            sessions = WibrFake::Listing.sessions_list_return
            if(sessions.empty?)
                warn "Sesion definida no existe"
            else
                sessions.each_with_index{|session, index|
                    index += 1
                    if(index==number.to_i)
                        workspace = session
                        status = true
                    elsif(session==number)
                        workspace = session
                        status = true
                    end
                }
                if(status)
                    puts "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Initialize session: #{workspace}"
                    return workspace
                else
                    warn "index o nombre de sesion no encontrada"
                    return status
                end
            end
        end
    end
end