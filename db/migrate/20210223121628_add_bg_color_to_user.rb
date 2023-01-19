class AddBgColorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bg_color, :string
  end
end
