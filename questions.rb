require 'sqlite3'
require 'singleton'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    User.all.each do |user|
      return user if user.id == id
    end
    puts "User with id #{id} not found."
  end

  def self.find_by_name(fname, lname)
    User.all.each do |user|
      return user if user.fname == fname && user.lname = lname
    end
    puts "User #{fname} #{lname} not found."
  end
end

class Question
  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    Question.all.each do |question|
      return question if question.id == id
    end
    puts "Question with id #{id} not found."
  end

  def self.find_by_author_id(author_id)
    Question.all.each do |question|
      return question if question.author_id == author_id
    end
    puts "Question with author_id #{author_id} not found."
  end


end

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_id(id)
    QuestionFollow.all.each do |follow|
      return follow if follow.id == id
    end
    puts "QuestionFollow with id #{id} not found."
  end

end

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.find_by_id(id)
    QuestionLike.all.each do |like|
      return like if like.id == id
    end
    puts "QuestionLike with id #{id} not found."
  end
end

class Reply
  attr_accessor :id, :question_id, :parent_id, :author_id, :body

  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    Reply.all.each do |reply|
      return reply if reply.id == id
    end
    puts "Reply with id #{id} not found."
  end

  def self.find_by_author_id(id)
    Reply.all.each do |reply|
      return reply if reply.author_id == id
    end
    puts "Reply with author_id #{id} not found."
  end

end
