require_relative 'questions'

class Question < ModelBase
  attr_accessor :id, :title, :body, :author_id

  def initialize(options)
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
    @id = options['id']
  end

  def self.find_by_author_id(author_id)
    questions = Question.all.select do |question|
      question.author_id == author_id
    end
    puts "Question with author_id #{author_id} not found." if questions.empty?
    questions
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

end

class QuestionFollow < ModelBase
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
    @id = options['id']
  end

  def self.followers_for_question_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT users.*
      FROM question_follows
      JOIN users ON (question_follows.user_id = users.id)
      WHERE question_follows.question_id = ?
    SQL
    data.map{ |datum| User.new(datum)}
  end

  def self.followed_questions_for_user_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT questions.*
      FROM question_follows
      JOIN questions ON (question_follows.question_id = questions.id)
      WHERE question_follows.user_id = ?
    SQL
    data.map{ |datum| Question.new(datum)}
  end

  def self.most_followed_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.*
      FROM question_follows
      JOIN questions ON (questions.id = question_follows.question_id)
      GROUP BY question_id
      ORDER BY COUNT(user_id) DESC
      LIMIT ?
    SQL
    data.map{ |datum| Question.new(datum)}
  end

end

class QuestionLike < ModelBase
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
    @id = options['id']
  end

  def self.likers_for_question_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT users.*
      FROM question_likes
      JOIN users ON (question_likes.user_id = users.id)
      WHERE question_likes.question_id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT COUNT(user_id) AS count
      FROM question_likes
      WHERE question_likes.question_id = ?
    SQL
    data.first['count']
  end

  def self.liked_questions_for_user_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT questions.*
      FROM question_likes
      JOIN questions ON (questions.id = question_likes.question_id)
      WHERE question_likes.user_id = ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.most_liked_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.*
      FROM question_likes
      JOIN questions ON (questions.id = question_likes.question_id)
      GROUP BY question_id
      ORDER BY COUNT(user_id) DESC
      LIMIT ?
    SQL
    data.map{ |datum| Question.new(datum)}
  end

end
