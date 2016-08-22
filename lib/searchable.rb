require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = []
    vals = []
    params.each do |k,v|
      where_line << "#{k} = ?"
      vals << "#{v}"
    end
    where_line = where_line.join(' AND ')
    returned = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
      SQL
    self.parse_all(returned)
  end
end

class SQLObject
  extend Searchable
end
