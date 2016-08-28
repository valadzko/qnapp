class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :body, length: { minimum: 15 }
  validates :user_id, presence: true
end
