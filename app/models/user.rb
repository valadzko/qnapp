class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers

  #  belongs_to :votable, polymorphic: true
  belongs_to :upvote, class_name: 'Answer', optional: true
  belongs_to :downvote, class_name: 'Answer', optional: true

  def author_of?(obj)
    obj.user_id == id
  end
end
