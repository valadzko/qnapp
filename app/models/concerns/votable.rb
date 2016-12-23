module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:status)
  end

  def upvote(user)
    vote(user, 1)
  end

  def reset_vote(user)
    to_delete = votes.where(user: user).first
    to_delete.delete if to_delete
  end

  def downvote(user)
    vote(user, -1)
  end

  private

  def vote(user, value)
    votes.where(user: user).first_or_initialize.tap do |vote|
      vote.update_attribute(:status, value)
    end
  end
end
