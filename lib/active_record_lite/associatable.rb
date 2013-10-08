require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require_relative './db_connection.rb'


#belongs_to :human, :class_name => "Human", :primary_key => :id, :foreign_key => :owner_id

class AssocParams
  attr_accessor :primary_key, :foreign_key, :other_class_name

  def other_class
    puts @other_class_name.constantize.class
    @other_class_name.constantize
  end

  def other_table
    @other_class_name.downcase + "s" #need to fix this as well as use otherclass.table_name
  end
end

class BelongsToAssocParams < AssocParams
  def initialize(name, params)
    @name = name
    @foreign_key = params[:foreign_key]
    @primary_key = params[:primary_key]
    @other_class_name = params[:class_name] || name.to_s.camelcase
        
  end

  def type
  end
end

class HasManyAssocParams < AssocParams
  def initialize(name, params, self_class)
  end

  def type
  end
end

module Associatable
  def assoc_params
    @assoc_params ||= {}
    @assoc_params
  end

  def belongs_to(name, params = {})

    assoc = BelongsToAssocParams.new(name, params)    
    assoc_params[name] = assoc

    define_method(name) do
      results = DBConnection.execute(<<-SQL, self.send(assoc.foreign_key))
        SELECT
            *
          FROM 
            #{assoc.other_table}
         WHERE
           #{assoc.other_table}.#{assoc.primary_key} = ?
      SQL
    
    assoc.other_class.parse_all(results).first
    end    
  end

  def has_many(name, params = {})
    assoc_params
    @assoc_params[name] = BelongsToAssocParams.new(name, params)

    define_method(name) do
      query = <<-SQL
        SELECT
          *
        FROM
          #{@assoc_params[name].other_table}
        WHERE
          @assoc_params[name].primary_key = ? 
      SQL
      
      results = DBConnection.execute(query, self.send(@assoc_params[name].foreign_key))
      
      @assoc_params[name].other_class.parse_all(results)
    end    


  end

  def has_one_through(name, assoc1, assoc2)
      
    
  end
end
