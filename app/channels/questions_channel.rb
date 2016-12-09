class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from "questions"
  end

  def follow_question_answers
    stream_from "question-#{params['id']}-answers"
  end
end
