class AddAdminAndOnlineToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :online, :boolean, default: false, null: false
  end
end
