class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 15 }

  accepts_nested_attributes_for :attachments, allow_destroy: true
end
