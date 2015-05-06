require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'user'
require_relative 'question_follow'
require_relative 'model'

class QuestionLike < Model

  def self.liked_questions_for_user_id(user_id)
    liked_attrs = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    liked_attrs.map { |attrs| Question.new(attrs) }
  end

  def self.likers_for_question_id(question_id)
    likers_attrs = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_likes
      JOIN users ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    likers_attrs.map { |attrs| User.new(attrs) }
  end

  def self.most_liked_questions(n)
    liked_attrs = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.author_id, questions.body, questions.title
      FROM
        question_likes
      JOIN questions ON questions.id = question_likes.question_id
      GROUP BY
        questions.id, questions.author_id, questions.body, questions.title
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    liked_attrs.map { |attrs| Question.new(attrs) }
  end

  def self.num_likes_for_question_id(question_id)
    num = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    num.first[0]
  end


  def initialize(attrs = {})
    @id, @user_id = attrs['id'], attrs['user_id']
    @question_id = attrs['question_id']
  end
end
