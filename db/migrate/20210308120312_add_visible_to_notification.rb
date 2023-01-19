class AddVisibleToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :visible_sender, :boolean, default: true, null: false
    add_column :notifications, :visible_receiver, :boolean, default: true, null: false
  end
end
