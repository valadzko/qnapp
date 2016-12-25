class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_vote_object
  before_action :authorize_parent

  respond_to :json

  def upvote
    @obj.upvote(current_user)
    new_rating
  end

  def downvote
    @obj.downvote(current_user)
    new_rating
  end

  def resetvote
    @obj.reset_vote(current_user)
    new_rating
  end

  private

  def authorize_parent
    authorize! :vote, @obj
  end

  def find_vote_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @obj = $1.classify.constantize.find(value)
      end
    end
  end

  def new_rating
    respond_to do |format|
      format.json { render json: {id: @obj.id, rating: @obj.rating } }
    end
  end
end
