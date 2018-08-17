class CreateBrokersUpdatePrefs < ActiveRecord::Migration[5.0]
  class BrokersUpdatePrefs < ActiveRecord::Base
  end

  class UpdatePrefs < ActiveRecord::Base
  end

  class Brokers < ActiveRecord::Base
  end

  def change
    create_table :brokers_update_prefs do |t|
      t.references :broker
      t.references :update_pref
    end

    wednesday = UpdatePref.find_by(day_of_week: 3)
    Broker.all.each do |broker|
      BrokersUpdatePrefs.create!(broker_id: broker.id, update_pref_id: wednesday.id)
    end
  end
end
