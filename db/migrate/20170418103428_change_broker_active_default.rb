class ChangeBrokerActiveDefault < ActiveRecord::Migration
  def change
    change_column_default :brokers, :active, false
  end
end
