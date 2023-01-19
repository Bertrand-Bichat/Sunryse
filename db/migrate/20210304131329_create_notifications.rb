class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.text :content
      t.boolean :readed, default: false, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
