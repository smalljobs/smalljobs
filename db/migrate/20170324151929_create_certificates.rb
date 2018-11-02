class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :title
      t.timestamps
    end

    add_index :certificates, :title
  end
end
