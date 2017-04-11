require 'sqlite3'
require 'singleton'
require_relative 'question_types'
require_relative 'reply'
require_relative 'user'

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
    table_name = TABLE_NAMES[self.class.to_s]
    data = QuestionDBConnection.instance.execute("SELECT * FROM #{table_name}")
    data.map { |datum| self.class.new(datum) }
  end

end
