require_relative 'questions_database'


class User
  attr_reader :fname, :lname, :id
  def initialize(attrs = {})
    @fname = attrs['fname']
    @lname = attrs['lname']
    @id = attrs['id']
  end

  def self.find_by_id(id)
    attrs = QuestionsDatabase.instance.execute(<<SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(attrs.first)
  end

  def self.find_by_name(fname, lname)
    attrs = QuestionsDatabase.instance.execute(<<SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    User.new(attrs.first)
  end
end
