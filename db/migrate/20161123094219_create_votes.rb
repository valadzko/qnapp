class CreateVotes < ActiveRecord::Migration[5.0]
  def change
     create_table :votes do |t|
       t.string  :votable_type
       t.integer :votable_id
       t.belongs_to :user, foreign_key: true, index: true
       t.integer :status, default: 0, index: true
       t.timestamps
     end
     add_index :votes, [:votable_id, :votable_type]
  end
end
