module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.upvotes.count - votes.downvotes.count
  end

  def upvote(user)
    vote(user, :upvote)
  end

  def reset_vote(user)
    vote(user, :default)
  end

  def downvote(user)
    vote(user, :downvote)
  end

  private

  def vote(user, status)
    votes.where(
      votable_type: self.class.name, votable_id: self.id, user_id: user.id
    ).first_or_initialize.tap do |vote|
      vote.update_attribute(:status, status)
    end
  end
end
