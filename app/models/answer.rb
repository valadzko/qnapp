class Answer < ApplicationRecord
  include Attachable
  #TODO : later - include Votable
  belongs_to :user
  belongs_to :question

  has_many :ups, :class_name => 'User', :foreign_key => 'upvote_id'
  has_many :downs, :class_name => 'User', :foreign_key => 'downvote_id'

  validates :body,:user_id, presence: true

  default_scope { order(accepted: :desc) }

  def mark_as_accepted
    Answer.transaction do
      question.answers.update_all(accepted:false)
      raise ActiveRecord::Rollback unless question.answers.where(accepted: true).first.nil?
      update(accepted:true)
    end
  end

  def rating
    ups.count - downs.count
  end

  def upvote(user)
    return if user.author_of?(self)
    vote(ups, downs, user)
  end

  def downvote(user)
    return if user.author_of?(self)
    vote(downs, ups, user)
  end

  private

  def vote(collection, opposite, user)
    if collection.include?(user)
      collection.delete(user)
    else
      collection << user
      opposite.delete(user)
    end
  end
end
