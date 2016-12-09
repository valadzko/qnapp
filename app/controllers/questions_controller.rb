class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  before_action :must_be_author!, only: [:destroy]
  after_action :publish_question, only: [:create]

  #respond_to :json, only: :create

  def index
    respond_with( @questions = Question.all )
  end

  def show
    @answer.attachments.build
    respond_with @question
  end

  def edit
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def must_be_author!
    unless current_user.author_of?(@question)
      redirect_to questions_path, error: "You can delete only your question"
    end
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/compact_view',
        locals: { q: @question }
      )
    )
  end

  def build_answer
    @answer = @question.answers.build
  end

  def find_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
