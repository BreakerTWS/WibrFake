require 'fileutils'
require 'thread'
require_relative "#{File.join(File.dirname(__FILE__), 'String', 'string')}"
animation = Thread.new do
    String.new.puts_spin "Setting WibrFake"
end

FileUtils.mkdir_p(File.expand_path("~/.local/share/icons/"))
FileUtils.mkdir_p(File.expand_path("~/.local/share/mime/packages/"))
FileUtils.mkdir_p(File.expand_path("~/.local/share/mime/application"))
FileUtils.cp_r("#{File.join(File.dirname(__FILE__), '..', '..', 'config', 'icons', 'hicolor')}", File.expand_path("~/.local/share/icons/"))
FileUtils.cp("#{File.join(File.dirname(__FILE__), '..', '..', 'config', 'icons', 'application-x-wkdump.xml')}", File.expand_path("~/.local/share/mime/packages/"))
FileUtils.cp("#{File.join(File.dirname(__FILE__), '..', '..', 'config', 'icons', 'wkdump.desktop')}", File.expand_path("~/.local/share/applications/"))
deskdb = Open3.capture3("update-desktop-database #{File.expand_path("~/.local/share/applications")}")
mimedb = Open3.capture3("update-mime-database #{File.expand_path("~/.local/share/mime")}")
mimedb = Open3.capture3("gtk-update-icon-cache -f #{File.expand_path("~/.local/share/icons/hicolor/")}")

animation.join
puts "configuration terminated, execute \"wibrfake --help\" for more information"
FileUtils.rm(File.join(File.dirname(__FILE__), 'config.rb'))
FileUtils.touch(File.join(File.dirname(__FILE__), 'config.rb'))
