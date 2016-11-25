class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :upvote_user, class_name: 'User'
  belongs_to :downvote_user, class_name: 'User'

end
