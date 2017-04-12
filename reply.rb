require_relative 'questions'

class Reply < ModelBase
  attr_accessor :id, :question_id, :parent_id, :author_id, :body

  def initialize(options)
    @author_id = options['author_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
    @id = options['id']
  end

  def self.find_by_author_id(id)
    replies = Reply.all.select do |reply|
      reply.author_id == id
    end
    puts "Replies with author_id #{id} not found." if replies.empty?
    replies
  end

  def self.find_by_question_id(id)
    questions = Reply.all.select do |reply|
      reply.question_id == id
    end
    puts "Questions with author_id #{id} not found." if questions.empty?
    questions
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    Reply.all.select do |reply|
      reply.parent_id == @id
    end
  end

end
