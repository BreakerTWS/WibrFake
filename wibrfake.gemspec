Gem::Specification.new do |info|
    info.name  = "wibrfake-brk"
    info.version = "0.0.2"
    info.executables << "wibrfake"
    info.description = "profesional tool for pentest wi-fi"
    #info.extensions = %w[ext/wibrfake/extconf.rb]
    
    # Dependencias
    info.add_dependency 'packetfu', '>= 0'
    info.add_dependency 'devise', '>= 0'
    info.add_dependency 'nio4r', '>= 0'
    info.add_dependency 'rails', '~> 7.2.2', '>= 7.2.2.1'
    info.add_dependency 'sprockets-rails', '>= 0'
    info.add_dependency 'sqlite3', '>= 0'
    info.add_dependency 'puma', '>= 5.0'
    info.add_dependency 'importmap-rails', '>= 0'
    info.add_dependency 'turbo-rails', '>= 0'
    info.add_dependency 'stimulus-rails', '>= 0'
    info.add_dependency 'jbuilder', '>= 0'
    info.add_dependency 'tzinfo-data', '>= 0'
    info.add_dependency 'concurrent-ruby', '>= 0'
    info.add_dependency 'web-console', '>= 0'
    info.add_dependency 'tty-reader', '>= 0'
    info.add_dependency 'pastel', '>= 0'
    info.add_dependency 'bootsnap', '>= 0'
    info.add_dependency 'brakeman', '>= 0'
    info.add_dependency 'rubocop-rails-omakase', '>= 0'
    info.add_dependency 'error_highlight', '>= 0.4.0'
    info.add_dependency 'capybara', '>= 0'
    info.add_dependency 'selenium-webdriver', '>= 0'
    info.add_dependency 'tty-cursor', '>= 0'
    info.add_dependency 'forwardable', '>= 0'
    info.add_dependency 'tty-screen', '>= 0'
    info.add_dependency 'sequel', '>= 0'
  
    # Dependencias de desarrollo y prueba
    info.add_development_dependency 'debug', '>= 0'
    info.add_development_dependency 'web-console', '>= 0'
    info.add_development_dependency 'error_highlight', '>= 0.4.0'
    info.add_development_dependency 'capybara', '>= 0'
  
    info.authors     = ["BreakerTWS"]
    info.email       = 'breakingtws@gmail.com'
    info.summary     = "Wibrfake is an advanced cybersecurity tool developed for the creation of fake access points"
    info.license     = "MIT"
    info.homepage    = 'https://github.com/BreakerTWS/WibrFake'
    info.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(/^.gitignore/)
    end
  end
