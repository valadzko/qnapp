class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :user
  enum status: [ :default, :upvote, :downvote ]

  scope :upvotes, -> { where(status: :upvote) }
  scope :downvotes, -> { where(status: :downvote) }

  validates :votable_id, :votable_type, :user_id, presence: true
end
