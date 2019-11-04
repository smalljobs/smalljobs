class CreateJobsCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs_certificates do |t|
      t.integer :seeker_id
      t.text :content
      t.uuid :jobs_certificate_id

      t.timestamps
    end
  end
end
