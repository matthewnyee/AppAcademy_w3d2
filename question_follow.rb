require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'user'
require_relative 'model'

class QuestionFollow < Model
  def self.followers_for_question_id(question_id)
    follower_attrs = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_follows
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL

    follower_attrs.map { |attrs| User.new(attrs) }
  end


  def self.followed_questions_for_user_id(user_id)
    followed_attrs = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.author_id, questions.body, questions.title
      FROM
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL

    followed_attrs.map { |attrs| Question.new(attrs) }
  end

  def self.most_followed_questions(n)
    followed_attrs = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.author_id, questions.body, questions.title
      FROM
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      GROUP BY
        questions.id, questions.author_id, questions.body, questions.title
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL

    followed_attrs.map { |attrs| Question.new(attrs) }
  end

  def initialize(attrs)
    @id, @question_id = attrs['id'], attrs['question_id']
    @user_id = attrs['user_id']
  end
end
