class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body,:user_id, presence: true
end
