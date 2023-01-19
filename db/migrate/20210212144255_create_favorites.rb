class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :profile_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
