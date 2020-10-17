class RenameImageColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :picture, :image
  end
end
