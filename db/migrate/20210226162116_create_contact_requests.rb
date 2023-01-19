class CreateContactRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_requests do |t|
      t.boolean :readed, default: false, null: false
      t.boolean :accepted, default: false, null: false
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
