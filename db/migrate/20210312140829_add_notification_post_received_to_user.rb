class AddNotificationPostReceivedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_post_received, :boolean, default: true, null: false
  end
end
