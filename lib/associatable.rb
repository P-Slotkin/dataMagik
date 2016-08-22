require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.downcase + 's'
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + '_id').to_sym
    @class_name = options[:class_name] || name[0].upcase + name[1..-1]
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.downcase + '_id').to_sym
    @class_name = options[:class_name] || name[0].upcase + name[1..-2]
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      opts = self.class.assoc_options[name]
      foreign_key = self.send(opts.foreign_key)
      output = opts.model_class.where(opts.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      opts = self.class.assoc_options[name]
      primary_key = self.send(opts.primary_key)
      output = opts.model_class.where(opts.foreign_key => primary_key)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      thru_opts = self.class.assoc_options[through_name]
      src_opts = thru_opts.model_class.assoc_options[source_name]
      thru_table = thru_opts.table_name
      src_table = src_opts.table_name
      thru_primary = thru_opts.primary_key
      thru_foreign = thru_opts.foreign_key
      src_primary = src_opts.primary_key
      src_foreign = src_opts.foreign_key
      foreign_key = self.send(thru_foreign)
      output = DBConnection.execute(<<-SQL, foreign_key)
        SELECT
        #{src_table}.*
        FROM
        #{thru_table}
        JOIN
        #{src_table}
        ON
        #{thru_table}.#{src_foreign} = #{src_table}.#{src_primary}
        WHERE
        #{thru_table}.#{thru_primary} = ?
      SQL
      src_opts.model_class.parse_all(output).first

    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
