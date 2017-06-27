class ChangePlacesZipToString < ActiveRecord::Migration
  def change
    change_column(:places, :zip, :string)
  end
end
