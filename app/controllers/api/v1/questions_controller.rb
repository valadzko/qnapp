class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_resource_owner)))
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
