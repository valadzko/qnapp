class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_question, only: [:new, :create, :destroy]
  before_action :find_answer, only: [:destroy]
  before_action :must_be_author!, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
      flash[:error] = 'Your answer was not updated'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def must_be_author!
    unless current_user.author_of?(@answer)
      redirect_to @question, error: "You can delete only your answer"
    end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = @question.answers.find(params[:id])
  end
end
