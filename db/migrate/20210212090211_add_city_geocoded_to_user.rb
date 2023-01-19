class AddCityGeocodedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :city_geocoded, :string
  end
end
