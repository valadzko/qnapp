class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body,:user_id, presence: true

  default_scope { order(accepted: :desc) }
  
  def mark_as_accepted
    question.answers.update_all(accepted:false)
    update(accepted:true)
  end

  def accepted?
    accepted
  end
end
