class AddDefaultBrokerToOrganizattion < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :default_broker_id, :integer
  end
end
