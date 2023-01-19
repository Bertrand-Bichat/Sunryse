class AddAuthorizedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authorized, :boolean, default: false, null: false
  end
end
