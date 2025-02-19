Gem::Specification.new do |info|
    info.name  = "wibrfake"
    info.version = "0.0.1"
    info.executables << "wibrfake"
    info.description = "profesional tool for pentest wi-fi"
    info.add_development_dependency "bundler", "~> 2.3"
    info.add_development_dependency "sqlite3", '~> 1.4', '>= 1.4.0'
    info.add_runtime_dependency "sqlite3", '~> 1.4', '>= 1.4.0'
    info.authors     = ["BreakerTWS"]
    info.email       = 'breakingtws@gmail.com'
    info.summary     = "Best tool for hacking wifi"

    info.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(/^.gitignore/)
    end
end
