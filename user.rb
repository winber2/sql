require_relative 'questions'

class User < ModelBase
  attr_accessor :id, :fname, :lname

  def initialize(options)
    @options = options
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name(fname, lname)
    User.all.each do |user|
      return user if user.fname == fname && user.lname = lname
    end
    puts "User #{fname} #{lname} not found."
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_author_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT CAST(count(question_likes.user_id) AS FLOAT) / count(DISTINCT(question_id)) AS average
      FROM users
      JOIN questions ON (questions.author_id = users.id)
      LEFT JOIN question_likes ON (questions.id = question_likes.question_id)
      WHERE users.id = ?
    SQL
    data.first['average']
  end

  # def save
  #   @id.nil? ? create : update
  # end
  #
  # def create
  #   QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname)
  #     INSERT INTO
  #       users (fname, lname)
  #     VALUES
  #       (?, ?)
  #   SQL
  #   @id = QuestionDBConnection.instance.last_insert_row_id
  # end
  #
  # def update
  #   QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
  #     UPDATE
  #       users
  #     SET
  #       fname = ?, lname = ?
  #     WHERE
  #       id = ?
  #   SQL
  #   puts "#{self} was updated"
  # end
end
