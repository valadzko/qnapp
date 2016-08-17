class Questions::AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

end
