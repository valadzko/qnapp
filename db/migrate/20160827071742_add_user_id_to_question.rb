class AddUserIdToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :questions, :user, index: true, foreign_key: true
  end
end
