class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  default_scope { order(:created_at) }
end
