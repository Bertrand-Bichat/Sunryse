class AddDataToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pseudo, :string, null: false
    add_column :users, :address, :string, null: false
    add_column :users, :birthday, :date, null: false
    add_column :users, :gender, :string, null: false
    add_column :users, :hair, :string, null: false
    add_column :users, :eye, :string, null: false
    add_column :users, :introduction, :string
    add_column :users, :description, :text
    add_column :users, :hobbies, :text
    add_column :users, :job, :text
    add_column :users, :qualities, :text
    add_column :users, :defaults, :text
    add_column :users, :i_want, :text
    add_column :users, :i_dont_want, :text
    add_column :users, :beliefs, :text
    add_column :users, :projects, :text
    add_column :users, :smoke, :boolean, null: false
    add_column :users, :want_child, :boolean, null: false
    add_column :users, :lives_alone, :boolean, null: false
    add_column :users, :movies, :text
    add_column :users, :books, :text
  end
end
