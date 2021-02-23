class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses, id: :integer do |t|
      t.string :image
      t.string :comment
      t.integer :user_id, foreign_key: true
      t.integer :order_id, foreign_key: true

      t.timestamps
    end
    add_index :responses, [:user_id, :order_id, :created_at]
  end
end
