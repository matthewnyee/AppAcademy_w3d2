require 'active_support/inflector'
require_relative 'questions_database'

class Model

  def self.search(search_conditions)
    condition_string_parts = []
    values = []
    search_conditions.each do |attr_name, value|
      condition_string_parts << "#{attr_name} = ?"
      values << value
    end

    condition_string = condition_string_parts.join(' AND ')

    model_attrs = QuestionsDatabase.instance.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table}
      WHERE
        #{condition_string}
    SQL
    model_attrs.map { |attrs| self.new(attrs) }
  end

  def self.method_missing(method_name, *args)
    method_name = method_name.to_s

    if method_name.start_with?('find_by')
      attributes_string = method_name[8..-1]
      attribute_names = attributes_string.split('_and_')
      p attribute_names
      p args
      raise 'unexpected # of args' unless attribute_names.length == args.length

      search_conditions = {}
      attribute_names.each_index do |i|
        search_conditions[attribute_names[i]] = args[i]
      end
      self.search(search_conditions)
    else
      super
    end
  end

  def save
    ivar_hash = instance_variable_hash
    id = ivar_hash.delete('id')

    if id.nil?
      column_names = ivar_hash.keys.join(', ')
      question_marks = Array.new(ivar_hash.length, '?').join(', ')

      QuestionsDatabase.instance.execute(<<-SQL, *ivar_hash.values)
        INSERT INTO
        #{table} (#{column_names})
        VALUES
        (#{question_marks})
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, *ivar_hash.values)
        UPDATE
        #{table}
        SET
        #{column_setters(ivar_hash)}
        WHERE
        id = ?
      SQL
    end
  end

  private

  def self.table
    self.name.to_s.underscore.pluralize
  end

  def instance_variable_hash
    results_hash = {}

    ivar_strings = instance_variables.map { |ivar| ivar.to_s[1..-1] }


    ivar_strings.each do |ivar_string|
      results_hash[ivar_string] = self.send(ivar_string)
    end

    results_hash
  end

  def column_setters(ivar_hash)
    setters = ivar_hash.keys.map { |ivar_name| "#{ivar_name} = ?"}
    setters.join(",\n")
  end
end
