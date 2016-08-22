require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    @many_things ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
    columns = @many_things.first
    cols = []
    columns.each do |el|
      cols << el.to_sym
    end
    cols
  end

  def self.finalize!
    self.columns.each do |name|
      define_method("#{name}") do
        attributes[name]
      end

      define_method("#{name}=") do |value|
        attributes[name] = value
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.downcase + "s"
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{@table_name}
      SQL
    self.parse_all(all)
  end

  def self.parse_all(results)
    results.map do |set|
      self.new(set)
    end
  end

  def self.find(id)
    one_object = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{@table_name}
      WHERE
        id = ?
      SQL
    parse_all(one_object).first

  end

  def initialize(params = {})
    params.each do |k, v|
      if self.class.columns.include?(k.to_sym)
        self.send("#{k}=", v)
      else
        raise "unknown attribute '#{k}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    values_array = []
    self.class.columns.each do |key|
      values_array << self.send(key)
    end
    values_array
  end

  def insert
    col_names_not_str = self.class.columns[1..-1].map {|el| el.to_s}
    col_names = col_names_not_str.join(', ')
    question_marks = ''
    (self.class.columns.count-1).times {question_marks += '?, '}
    question_marks = question_marks.chop.chop
    DBConnection.execute(<<-SQL, *attribute_values[1..-1])
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
      SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    keys_and_values_array = []
    counter = 1
    while counter < attribute_values.length
      keys_and_values_array << "#{self.class.columns[counter]} = ?"
      counter += 1
    end
    keys_and_values_array = keys_and_values_array.join(",")
    DBConnection.execute(<<-SQL, *attribute_values[1..-1], self.send(:id))
      UPDATE
        #{self.class.table_name}
      SET
        #{keys_and_values_array}
      WHERE
        id = ?
      SQL
  end

  def save
    if id.nil?
      self.insert
    else
      self.update
    end
  end
end
