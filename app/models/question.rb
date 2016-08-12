class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :body, length: { minimum: 15 }
end
