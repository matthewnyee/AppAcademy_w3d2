require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'model'

class User < Model
  TABLE = 'users'

  def self.find_by_name(fname, lname)
    find_by_fname_and_lname(fname, lname)
  end

  attr_accessor :fname, :lname, :id

  def initialize(attrs = {})
    @fname = attrs['fname']
    @lname = attrs['lname']
    @id = attrs['id']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    average = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        num_questions / CAST(num_likes AS FLOAT)
      FROM (
        SELECT
          COUNT(DISTINCT(questions.id)) as num_questions, COUNT(*) as num_likes
        FROM
          questions
        LEFT OUTER JOIN
          question_likes ON questions.id = question_likes.question_id
        WHERE
          question_likes.user_id = ?
      )
    SQL
    average.first[0]
  end
end
