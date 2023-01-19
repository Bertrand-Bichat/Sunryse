class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.references :speaker1, foreign_key: { to_table: :users }
      t.references :speaker2, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
