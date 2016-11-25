module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def rating
    ups.count - downs.count
  end

  def upvote(user)
    return if user.author_of?(self)
    vote(ups, downs, user)
  end

  def downvote(user)
    return if user.author_of?(self)
    vote(downs, ups, user)
  end

  private

  def vote(collection, opposite, user)
    if collection.include?(user)
      collection.delete(user)
    else
      collection << user
      opposite.delete(user)
    end
  end

end
