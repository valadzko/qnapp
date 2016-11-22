class AddVotableToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :upvote, references: :answers, index: true
    add_foreign_key :users, :answers, column: :upvote
    add_reference :users, :downvote, references: :answers, index: true
    add_foreign_key :users, :answers, column: :downvote
  end
end
