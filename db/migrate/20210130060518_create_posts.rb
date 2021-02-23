class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, id: :integer do |t|
      t.string :english
      t.string :japanese
      t.string :image
      t.string :comment
      t.integer :user_id, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
