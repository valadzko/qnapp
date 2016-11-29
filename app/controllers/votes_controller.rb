class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_vote_object
  before_action :must_not_be_author!

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

  def find_vote_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @obj = $1.classify.constantize.find(value)
      end
    end
  end

  def must_not_be_author!
    if current_user.author_of?(@obj)
      respond_to do |format|
        format.json { render json: {id: @obj.id, errors: 'Author can not vote!'}, status: :unprocessable_entity }
      end
    end
  end

  def new_rating
    respond_to do |format|
      format.json { render json: {id: @obj.id, rating: @obj.rating } }
    end
  end
end
