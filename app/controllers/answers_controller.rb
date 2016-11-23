class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :upvote, :downvote]
  before_action :find_answer, only: [:destroy, :update, :accept, :upvote, :downvote]
  before_action :must_be_author!, only: [:destroy, :update, :accept]
  before_action :must_not_be_author!, only: [:upvote, :downvote]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def accept
    @question = @answer.question
    @answer.mark_as_accepted
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
  end

  def upvote
   @answer.upvote(current_user)
   respond_to do |format|
     format.json { render json: { id: @answer.id, rating: @answer.rating } }
   end
  end

  def downvote
    @answer.downvote(current_user)
    respond_to do |format|
      format.json { render json: { id: @answer.id, rating: @answer.rating } }
    end
  end

  private

  def must_not_be_author!
    if current_user.author_of?(@answer)
      respond_to do |format|
        format.json { render json: {id: @answer.id, errors: 'Author can not vote for his answer'}, status: :unprocessable_entity }
      end
    end
  end

  def must_be_author!
    unless current_user.author_of?(@answer)
      redirect_to @answer.question, error: "You can delete only your answer"
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
