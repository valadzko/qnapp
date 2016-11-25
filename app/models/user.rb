class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers

  has_many :upvotes, class_name: 'Vote', foreign_key: 'upvote_user_id'
  has_many :downvotes, class_name: 'Vote', foreign_key: 'downvote_user_id'

#  belongs_to :votable, polymorphic: true
#  belongs_to :upvote, class_name: 'Answer', optional: true
#  belongs_to :downvote, class_name: 'Answer', optional: true

#  belongs_to :question_upvote, class_name: 'Question', optional: true
#  belongs_to :question_downvote, class_name: 'Question', optional: true

  def author_of?(obj)
    obj.user_id == id
  end
end
