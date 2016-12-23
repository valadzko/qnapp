class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :find_answer, only: [:destroy, :update, :accept]
  before_action :find_question, only: :create
  after_action :publish_answer, only: [:create]

  respond_to :js
  respond_to :json, only: :create

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def accept
    @answer.mark_as_accepted
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question-#{@answer.question.id}-answers",
      rendering_params
    )
  end

  def rendering_params
    gon.question_author_id = @answer.question.user_id
    return @answer.as_json.merge(
      rating: @answer.rating,
      user: @answer.user.to_json,
      attachments: @answer.attachments.to_json,
    ).to_json
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = @answer.nil? ? Question.find(params[:question_id]) : @answer.question
  end

  def find_answer
    @answer = Answer.find(params[:id])
    find_question
  end
end
