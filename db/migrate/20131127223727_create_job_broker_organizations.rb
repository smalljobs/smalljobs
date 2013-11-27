class CreateJobBrokerOrganizations < ActiveRecord::Migration
  def change
    create_table :job_broker_organizations do |t|
      t.references :job_broker
      t.references :organization
      t.references :region

      t.timestamps
    end
  end
end
