class Question < ApplicationRecord
  include Attachable
  belongs_to :user
  has_many :answers, dependent: :destroy

#  has_many :ups, :class_name => 'User', :foreign_key => 'question_upvote_id'
#  has_many :downs, :class_name => 'User', :foreign_key => 'question_downvote_id'

  validates :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 15 }
end
