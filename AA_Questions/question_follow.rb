require_relative 'requires'

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.followers_for_question_id(question_id)
    users = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        questions_follows ON users.id = questions_follows.user_id
      WHERE
        questions_follows.question_id = ?
    SQL
    return nil unless users.length  > 0

    users.map do |user|
      User.new(user)
    end
  end

  def self.followed_questions_for_user_id(user_id)

    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        questions_follows ON questions.id = questions_follows.user_id
      WHERE
        questions_follows.user_id = ?
    SQL
    return nil unless questions.length  > 0

    questions.map do |question|
      Question.new(question)
    end
  end

  def self.most_followed_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        questions_follows ON questions.id = questions_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_id) DESC
      LIMIT
        ?
    SQL
    return nil unless questions.length > 0
    questions.map do |question|
      Question.new(question)
    end
  end

end
