module Searchable
  def where(params)


    keys = params.keys
    values = params.values

    keys_question_marks = keys.join('= ? AND ') + " = ?"

    query = <<-SQL
    SELECT
      *
    FROM
      #{@table_name}
    WHERE
      #{keys_question_marks}
    SQL

    selections =  DBConnection.execute(query, *values)

    selections.map do |selection|
      self.new(selection)
    end

  end
end