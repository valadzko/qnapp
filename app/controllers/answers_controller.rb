class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.new(user: current_user)
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
