require_relative 'requires'

class QuestionLike

  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    return nil unless likers.length > 0
    likers.map do |liker|
      User.new(liker)
    end
  end

  def self.num_likes_for_question_id(question_id)
    count = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL
    count.first["COUNT(*)"]
  end

  # def self.liked_questions_for_user_id(user_id)
  #   count = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
  # end

end
