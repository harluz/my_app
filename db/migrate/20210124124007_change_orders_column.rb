class ChangeOrdersColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :word_id, :integer
    add_column :orders, :english, :string
    add_column :orders, :japanese, :string
  end
end
