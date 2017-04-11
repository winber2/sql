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
