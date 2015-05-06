require_relative 'questions_database'
require_relative 'reply'
require_relative 'user'
require_relative 'question_follow'
require_relative 'model'

class Question < Model
  TABLE = 'questions'

  def self.find_by_author_id(author_id)
    question_attrs = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    question_attrs.map { |attrs| Question.new(attrs)}
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_reader :id, :author_id, :title, :body

  def initialize(attrs = {})
    @id, @author_id = attrs['id'], attrs['author_id']
    @title, @body = attrs['title'], attrs['body']
  end

  def author
    User.find_by_id(author_id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

end
