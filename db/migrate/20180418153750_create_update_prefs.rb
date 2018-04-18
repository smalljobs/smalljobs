class CreateUpdatePrefs < ActiveRecord::Migration[5.0]
  class UpdatePrefs < ActiveRecord::Base
  end

  def change
    create_table :update_prefs do |t|
      t.string :name
      t.integer :day_of_week
      t.timestamps
    end

    UpdatePrefs.create!(name: 'Sonntag', day_of_week: 0)
    UpdatePrefs.create!(name: 'Montag', day_of_week: 1)
    UpdatePrefs.create!(name: 'Dienstag', day_of_week: 2)
    UpdatePrefs.create!(name: 'Mittwoch', day_of_week: 3)
    UpdatePrefs.create!(name: 'Donnerstag', day_of_week: 4)
    UpdatePrefs.create!(name: 'Freitag', day_of_week: 5)
    UpdatePrefs.create!(name: 'Samstag', day_of_week: 6)
  end
end
