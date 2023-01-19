class AddVisibleToContactRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :contact_requests, :visible_sender, :boolean, default: true, null: false
    add_column :contact_requests, :visible_receiver, :boolean, default: true, null: false
  end
end
