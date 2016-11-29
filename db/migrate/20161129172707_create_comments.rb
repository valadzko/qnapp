class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.string  :commentable_type
      t.integer :commentable_id
      t.belongs_to :user, foreign_key: true, index: true

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]

  end
end
