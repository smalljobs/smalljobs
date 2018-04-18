class BrokerUpdatePref < ActiveRecord::Base
  belongs_to :broker
  belongs_to :update_pref
end
