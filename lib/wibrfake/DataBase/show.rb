require 'sqlite3'

db = SQLite3::Database.new "ouis.db"

rows = db.execute("SELECT id, name FROM ouis_mac WHERE oui = ?", "f2:1a:af")
a = ''
puts "ID\tOUIS\t\tNAME"
puts "-" * 30
rows.each do |row|
    if row.empty?
        puts "No se encontro el oui"
    else
        puts "Index: #{row[0]}"
        puts "Name: #{row[1]}"
    end
end
db.close
puts a