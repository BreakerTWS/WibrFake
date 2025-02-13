require 'sqlite3'

# Abrir la base de datos existente
db = SQLite3::Database.new "howuis.db"  # Asegúrate de que este sea el nombre correcto de tu base de datos

# Renombrar la tabla de howuis_mac a ouis_mac
db.execute("ALTER TABLE howuis_mac RENAME TO ouis_mac;")

# Renombrar la columna de howui a oui
db.execute("ALTER TABLE ouis_mac RENAME COLUMN howui TO oui;")

# Cerrar la base de datos
db.close

puts "Tabla y columna renombradas correctamente."
