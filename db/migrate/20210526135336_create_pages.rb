class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :tag
      t.string :title
      t.string :quote
      t.text :content

      t.timestamps
    end
  end
end
