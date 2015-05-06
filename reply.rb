require_relative 'questions_database'
require_relative 'question'
require_relative 'user'
require_relative 'question_follow'
require_relative 'model'
require 'set'

class Reply < Model
  attr_reader :id, :parent_id, :body, :author_id, :question_id

  def initialize(attrs = {})
    super

    @id, @parent_id, @body = attrs['id'], attrs['parent_id'], attrs['body']
    @author_id, @question_id = attrs['author_id'], attrs['question_id']
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    Reply.find_by_parent_id(id)
  end
end
