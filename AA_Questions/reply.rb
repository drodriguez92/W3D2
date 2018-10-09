require_relative 'requires'

class Reply

  attr_accessor :id, :body, :question_id, :parent_reply_id, :author_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @body = options['body']
    @author_id = options['author_id']
    @parent_reply_id = options['parent_reply_id']
  end


  def self.find_by_user_id(author_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.author_id = ?
    SQL
    return nil unless replies.length > 0

    replies.map do |reply|
      Reply.new(reply)
    end
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL
    return nil unless replies.length > 0

    replies.map do |reply|
      Reply.new(reply)
    end
  end


  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    reply = QuestionsDBConnection.instance.execute(<<-SQL, @parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    return nil unless reply.length > 0

    Reply.new(reply.first)
  end

  def child_replies
    reply = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = ?
    SQL
    return nil unless reply.length > 0

    Reply.new(reply.first)
  end
end
