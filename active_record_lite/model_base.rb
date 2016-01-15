require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'searchable'
require_relative 'associatable'

class model_base
  extend Searchable
  extend Associatable

  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL).first
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    cols.map!(&:to_sym)
    @columns = cols

  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def self.table_name=(name)
      @table_name = name
  end

  def self.table_name
    @table_name ||=  self.name.underscore.pluralize
  end

  def self.all
    result_hashes = DBConnection.execute(<<-SQL)
      SELECT
      #{table_name}.*
      FROM
      #{table_name}
      SQL
      self.parse_all(result_hashes)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    # ...
    results = DBConnection.execute(<<-SQL, id)
      SELECT
      #{table_name}.*
      FROM
      #{table_name}
      WHERE
      #{table_name}.id = ?
      SQL

      parse_all(results).first
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| self.send(attr) }
  end

  def insert
    # ...
    columns = self.class.columns.drop(1)
    col_names = columns.map(&:to_s).join(", ")
    question_marks = (["?"] * columns.count).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
      SQL
      self.id = DBConnection.last_insert_row_id
  end

  def update
    # ...
    set_line = self.class.columns
    .map { |attr| "#{attr} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def save
    # ...
    id.nil? ? insert : update
  end
end
