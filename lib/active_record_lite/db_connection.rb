require 'sqlite3'

class DBConnection
  def self.filename
    @filename
  end

  def self.open(db_file_name)
    @filename = db_file_name
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true
  end

  def self.execute(*args)
    @db.execute(*args)
  end

  private
  def initialize(db_file_name)
  end
end
