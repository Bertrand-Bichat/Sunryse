class AddCriteriasToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender_criteria, :string, null: false
    add_column :users, :goal, :string, null: false
    add_column :users, :min_age, :integer, null: false
    add_column :users, :max_age, :integer, null: false
    add_column :users, :perimeter_criteria, :integer, null: false
    add_column :users, :shape_criteria, :string, array: true, default: []
    add_index :users, :shape_criteria, using: 'gin'
  end
end
