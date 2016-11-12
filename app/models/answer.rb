class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable

  validates :body,:user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(accepted: :desc) }

  def mark_as_accepted
    Answer.transaction do
      question.answers.update_all(accepted:false)
      raise ActiveRecord::Rollback unless question.answers.where(accepted: true).first.nil?
      update(accepted:true)
    end
  end
end
