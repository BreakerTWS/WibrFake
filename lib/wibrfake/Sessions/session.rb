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
            rescue Errno::EEXIST
                warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m Session: #{@id} already exists"
            end
        end
        
        def rename(number: nil, name: nil, id: nil)
            sessions = WibrFake::Listing.sessions_list_return
            status = false
            verify_session = false
            if(sessions.empty?)
                warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m No active sessions"
            else
                sessions.each_with_index{|session, index|
                    index += 1
                    if(index==number.to_i)
                        begin
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', session), File.join(File.dirname(__FILE__), '..', 'Tmp', name))
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{session}.wkdump"), File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{name}.wkdump"))
                        rescue Errno::EINVAL
                            warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The session name already exists"
                        end
                        verify_session = "current" if (session==id)
                        status = true
                    elsif(session==number)
                        begin
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', session), File.join(File.dirname(__FILE__), '..', 'Tmp', name))
                            FileUtils.mv(File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{session}.wkdump"), File.join(File.dirname(__FILE__), '..', 'Tmp', name, 'wkdump', "#{name}.wkdump"))
                            print "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Session [#{session}] was renamed to: #{name}          "
                            puts
                            
                        rescue Errno::EINVAL
                            warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The session name already exists"
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
                    warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The session index or name was not found"
                    return status
                end
            end
        end
        def remove(number: nil, id: nil)
            status = false
            eliminated = false
            sessions = WibrFake::Listing.sessions_list_return
            if(sessions.empty?)
                warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The specified session does not exist"
            else
                sessions.each_with_index{|session, index|
                    index += 1
                    if(index==number.to_i)
                        if(id==session)
                            status = true
                        end
                        eliminated = true
                        FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'Tmp', session))
                        print "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Session: #{session} has been removed"
                        puts
                    elsif(session==number)
                        if(id==session)
                            status = true
                        end
                        eliminated = true
                        FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'Tmp', session))
                        print "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Session: #{session} has been removed"
                        puts
                    end
                }
            end
            if(!eliminated)
                warn "\n\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The session '#{number}' does not exist"
            end
            return status
        end
        def active(id: nil)
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
                warn "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Session settings activated and saved successfully"
            end
        end
        def save(id: nil)
            config_yml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'config.yml'))
            if(id.nil?)
                puts
            else
                config_session = {
                    'WibrFake' => 'Config',
                    'session' => {
                        'session_save' => config_yml['session']['session_save'],
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
                warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m Session defined does not exist"
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
                    puts "\033[38;5;46m[\e[1;37m+\033[38;5;46m]\e[1;37m Initializing session: #{workspace}"
                    return workspace
                else
                    warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m The session index or name was not found"
                    return status
                end
            end
        end
        def session_modified(status: false, id: nil)
            if(id.nil?)
                warn "\e[1;33m[\e[1;37m+\e[1;33m]\e[1;37m Session ID not found"
            else
                #Load config.yml file
                config_yml = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'config.yml'))
                if(status)
                    config_session = {
                        'WibrFake' => 'Config',
                        'session' => {
                            'session_save' => config_yml['session']['session_save'],
                            'session_modified' => true,
                            'name' => config_yml['session']['name']
                        }
                    }
                    File.open(File.join(File.dirname(__FILE__), '..', 'Tmp', id, 'config.yml'), 'w'){|file|
                        file.write(config_session.to_yaml)
                    }
                end
            end
        end
    end
end