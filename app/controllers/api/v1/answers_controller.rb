class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = Question.find(params[:question_id]).try(:answers)
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end
end
