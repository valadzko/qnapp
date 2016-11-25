class Answer < ApplicationRecord
  include Attachable
  include Votable
  belongs_to :user
  belongs_to :question

  validates :body,:user_id, presence: true

  default_scope { order(accepted: :desc) }

  def mark_as_accepted
    Answer.transaction do
      question.answers.update_all(accepted:false)
      raise ActiveRecord::Rollback unless question.answers.where(accepted: true).first.nil?
      update(accepted:true)
    end
  end
end
