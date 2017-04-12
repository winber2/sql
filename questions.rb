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
    question_marks = (["?"] * @options.values.length).join(", ")
    QuestionDBConnection.instance.execute(<<-SQL, *@options.values)
      INSERT INTO
        users (#{@options.keys.join(", ")})
      VALUES
        (#{question_marks})
    SQL
    @id = QuestionDBConnection.instance.last_insert_row_id
  end

  def update
    QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
    puts "#{self} was updated"
  end

  # def instance_variables
  #   hash = {}
  #   table = self.instance_variables.map do |el|
  #     hash[el.to_s[1..-1]] = self.instance_variable_get(el)
  #   end
  #   hash
  # end

end

require_relative 'question_types'
require_relative 'reply'
require_relative 'user'
