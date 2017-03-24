class CreateCertificatesSeekers < ActiveRecord::Migration
  def change
    create_table :certificates_seekers do |t|
      t.references :seeker
      t.references :certificate
    end
  end
end
