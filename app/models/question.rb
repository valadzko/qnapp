class Question < ApplicationRecord
  include Attachable
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 15 }
end
