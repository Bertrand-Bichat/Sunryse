class AddAvatarBorderColorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_border_color, :string
  end
end
