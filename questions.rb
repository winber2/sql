require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class ModelBase
  attr_accessor :id

  TABLE_NAMES = {
    'User' => 'users',
    'Question' => 'questions',
    'QuestionLike' => 'question_likes',
    'QuestionFollow' => 'question_follows',
    'Reply' => 'replies'
  }

  def initialize(options)
    @id = options['id']
  end

  def self.all
    table_name = TABLE_NAMES[self.to_s]
    data = QuestionDBConnection.instance.execute("SELECT * FROM #{table_name}")
    data.map { |datum| self.new(datum) }
  end

  def self.find_by_id(id)
    self.all.each do |instance|
      return instance if instance.id == id
    end
    puts "#{self.to_s} with id #{id} not found."
  end

  def save
    @id.nil? ? create : update
  end

  def create
    variables = instances
    variables.delete('id')
    question_marks = (["?"] * variables.values.length).join(", ")
    QuestionDBConnection.instance.execute(<<-SQL, *variables.values)
      INSERT INTO
        #{TABLE_NAMES[self.class.to_s]} (#{variables.keys.join(", ")})
      VALUES
        (#{question_marks})
    SQL
    @id = QuestionDBConnection.instance.last_insert_row_id
  end

  def update
    variables = instances
    set_expression = variables.keys[0...-1].map {|key| key + " = ?"}.join(", ")
    QuestionDBConnection.instance.execute(<<-SQL, *variables.values)
      UPDATE
        #{TABLE_NAMES[self.class.to_s]}
      SET
        #{set_expression}
      WHERE
        id = ?
    SQL
    puts "#{self.class} was updated"
  end

  def instances
    hash = {}
    table = self.instance_variables.map do |el|
      hash[el.to_s[1..-1]] = self.instance_variable_get(el)
    end
    hash
  end

  def self.where(options)
    column_names =  options.keys.map {|key| key + " = ?"}.join(" AND ")
    data = QuestionDBConnection.instance.execute(<<-SQL, *options.values)
      SELECT *
      FROM #{TABLE_NAMES[self.to_s]}
      WHERE #{column_names}
    SQL
    data.map { |datum| self.new(datum) }
  end

  def self.method_missing(*args)
    method_name = args.first.to_s
    if method_name.start_with?('find_by_')
      string = method_name[8..-1]
      keys = string.split("_").select.with_index do |exp, idx|
        idx.even?
      end

      values = args[1..-1]
      raise ArgumentError, 'Mismatched Keys' unless keys.length == values.length
      options = keys.zip(values).to_h
      self.where(options)
    else
      super
    end
  end

end

require_relative 'question_types'
require_relative 'reply'
require_relative 'user'
