require 'sqlite3'

howui = Array.new
name = Array.new
db = SQLite3::Database.new "ouis.db"

# Crear la tabla howuis_mac si no existe
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS howuis_mac (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    howui TEXT,
    name TEXT
  );
SQL

# Insertar los datos en la tabla
howui.each_with_index do |h, index|
  db.execute("INSERT INTO howuis_mac (howui, name) VALUES (?, ?)", [h, name[index]])
end

# Cerrar la base de datos
db.close

puts "Datos insertados correctamente en la base de datos."