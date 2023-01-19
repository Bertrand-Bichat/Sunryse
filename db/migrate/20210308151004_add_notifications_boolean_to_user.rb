class AddNotificationsBooleanToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_profil_seen, :boolean, default: true, null: false
    add_column :users, :notification_favorite_added, :boolean, default: true, null: false
    add_column :users, :notification_contact_request_readed, :boolean, default: true, null: false
    add_column :users, :notification_contact_request_accepted, :boolean, default: true, null: false
    add_column :users, :notification_contact_request_received, :boolean, default: true, null: false
  end
end
