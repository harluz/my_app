class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders, id: :integer do |t|
      t.text :comment
      t.integer :user_id, foreign_key: true
      t.integer :word_id, foreign_key: true

      t.timestamps
    end
    add_index :orders, [:user_id, :word_id, :created_at]
  end
end
