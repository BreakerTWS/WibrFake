Rails.application.routes.draw do
  # Respuesta 204 para detección de portal cautivo
  get 'about/', to: 'sessions#wibrfake_about'
  get 'nauta/', to: 'sessions#nauta', as: :nauta_login
  post 'nauta/', to: 'sessions#nauta_login', as: :nauta_login_post
  #post 'generate_204/', to: 'sessions#nauta_login', as: :nauta_login_post
  # Redirigir todo el tráfico HTTP al portal de login
  #get '*path', to: 'sessions#nauta_login', constraints: ->(req) { !req.path.start_with?('/assets') }
  
  # Ruta principal
  root 'sessions#wibrfake'
end