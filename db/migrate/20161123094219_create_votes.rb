class CreateVotes < ActiveRecord::Migration[5.0]
  def change
     create_table :votes do |t|
       t.string  :votable_type, index: true
       t.integer :votable_id, index: true
       t.belongs_to :user, foreign_key: true, index: true
       t.column :status, :integer, default: 0
       t.timestamps
     end
  end
end
