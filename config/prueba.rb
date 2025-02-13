# Gemfile: gem 'puma'
=begin
require 'puma'
require_relative 'environment'

Rails.application.routes.clear!

Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root to: "sessions#index", as: :page_index
  get 'login/basic', to: 'sessions#basic', as: :basic_login
  post 'login/basic', to: 'sessions#basic_login', as: :basic_login_post
  get 'login/puta', to: 'sessions#nauta', as: :nauta_login
  #get 'generate_204', to: 'sessions#nauta', as: :nauta_login
  post 'login/puta', to: 'sessions#nauta_login', as: :nauta_login_post
  #post 'generate_204', to: 'sessions#nauta_login', as: :nauta_login_post
  #root to: 'sessions#basic', as: :basic_login 
end



Puma::Server.new(Rails.application).tap do |s|
  s.add_tcp_listener "0.0.0.0", 5678
end.run.join
=end

module WibrFake
  class Rails
      def initialize(host="0.0.0.0", port=3000, login="basic", test=1)
          begin
              require 'puma'
              require_relative '../lib/wibrfake/Rails/routes'
              
          rescue LoadError =>e
            puts e.message
              puts "Error al cargar una libreria"
          end
          @host = host
          @port = port
          @login = login
          @test = test
      end

      def start
          route_root, route_login = WibrFake::Rails.routes(@login, @test)
          require_relative 'environment'
          ::Rails.application.routes.clear!
          ::Rails.application.routes.draw {
              devise_for :users
              root to: route_root[:sessions_get], as: route_root[:as_get]
              get route_login[:route], to: route_login[:sessions_get], as: route_login[:as_get]
              get route_login[:route], to: route_login[:sessions_post], as: route_login[:as_post]
          }
          Puma::Server.new(Rails.application).tap {|server|
              server.add_tcp_listener @host, @port
          }.run.join
      end
  end
end