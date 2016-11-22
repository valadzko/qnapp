module Votable
  extend ActiveSupport::Concern

  included do
    has_many :upvotes, as: :user
    has_many :downvotes, as: :user

    #TODO author can not vote for his own votable
    #TODO add migrations for answer and question.
    # Ask about making migration with concern
    #TODO clarify about double voting with one value (
    # double vote up / double vote down
    #
    # def rating
    #   upvotes.count - downvotes.count
    # end
    #
    # def up_vote(user)
    #   vote(upvotes, downvotes, user)
    # end
    #
    # def down_vote(user)
    #   vote(downvotes, upvotes, user)
    # end
    #
    # private
    #
    # def vote(collection, opposite_collection, user)
    #   return "author can not vote" if user.author_of(self)
    #   if collection.has?(user)
    #     collection.remove(user)
    #   else
    #     collection.add(user)
    #     opposite_collection.remove(user) # if any only!
    #   end
    # end

  end
end
