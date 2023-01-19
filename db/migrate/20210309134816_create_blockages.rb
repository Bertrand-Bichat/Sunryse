class CreateBlockages < ActiveRecord::Migration[5.2]
  def change
    create_table :blockages do |t|
      t.references :initiator, foreign_key: { to_table: :users }
      t.references :target, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
