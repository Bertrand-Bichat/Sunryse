class AddPhoneNumberToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :phone_number, :string
  end
end
