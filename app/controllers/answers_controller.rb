class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update, :accept]
  before_action :must_be_author!, only: [:destroy, :update, :accept]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def accept
    @answer.mark_as_accepted
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
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
    find_question
    @answer = @question.answers.find(params[:id])
  end
end
