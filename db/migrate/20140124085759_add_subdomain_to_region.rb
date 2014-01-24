class AddSubdomainToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :subdomain, :string
    add_index :regions, :subdomain

    Region.find_each do |region|
      subdomain = region.name.downcase.tr(' ', '-').gsub(/[^0-9a-z-]/i, '')
      region.update_attribute(:subdomain, subdomain)
    end

    change_column_null :regions, :subdomain, false
  end
end
