class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :player1, foreign_key: { to_table: :users }
      t.references :player2, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
