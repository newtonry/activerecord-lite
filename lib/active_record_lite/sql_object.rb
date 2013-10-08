require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'

class SQLObject < MassObject
  extend Searchable
  extend Associatable
#  attr_accessor :table_name # might not need this


  def self.set_table_name table
    @table_name = table
  end


  def table_name
    @table_name = self.class.to_s.downcase << "s" #should use pluralize
    @table_name
  end

  def self.all

    DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{@table_name}
    SQL
  end



  def self.find(id)

    found_object = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{@table_name}
    WHERE id = ?
    SQL
    .first

    self.new(found_object)


  end

  def create
  end

  def update
    obj_id = self.send(:id)

    index_of_id = @attributes.find_index(:id)
    attrs_min_id = @attributes - [:id]
    attr_vals_minus_id = attribute_values[0...index_of_id] + attribute_values[index_of_id + 1 ..-1]

    attr_string = attrs_min_id.map {|attr_name| attr_name.to_s}
    update_values = attr_string.join(" = ?, ") + " = ?"

    query = <<-SQL
        UPDATE
          #{table_name}
        SET
          #{update_values}
        WHERE id = ?
      SQL

      attr_vals_minus_id << obj_id

      DBConnection.execute(query, *attr_vals_minus_id)

  end


  def save

    if @attributes.include?(:id)
      self.update
    else
      self.create
    end
  end



  def create

    attr_string = @attributes.map {|attr_name| attr_name.to_s}
    question_marks = (['?'] * @attributes.length).join(', ')

    query = <<-SQL
    INSERT INTO
      #{table_name} (attr_string)
    VALUES
      #{question_marks}
    SQL



    DBConnection.execute(query, *attribute_values)

  end

  def attribute_values
    @attributes.map do |instance_name|
      self.send(instance_name.to_sym)
    end
  end
end