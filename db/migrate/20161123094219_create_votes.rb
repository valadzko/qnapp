class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.string  :votable_type
      t.integer :votable_id

      t.timestamps
    end
    add_index :votes, [:votable_id, :votable_type]

    add_column :users, :upvote_user_id, :integer
    add_index :users, :upvote_user_id

    add_column :users, :downvote_user_id, :integer
    add_index :users, :downvote_user_id

    add_reference :votes, :upvote_user, references: :users, index: true
    add_foreign_key :votes, :users, column: :upvote_user_id

    add_reference :votes, :downvote_user, references: :users, index: true
    add_foreign_key :votes, :users, column: :downvote_user_id
  end
end
