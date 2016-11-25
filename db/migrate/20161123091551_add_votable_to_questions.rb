class AddVotableToQuestions < ActiveRecord::Migration[5.0]
  def change
    # add_reference :users, :question_upvote, references: :questions, index: true
    # add_foreign_key :users, :questions, column: :question_upvote
    # add_reference :users, :question_downvote, references: :questions, index: true
    # add_foreign_key :users, :questions, column: :question_downvote
  end
end
