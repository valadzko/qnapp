class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
