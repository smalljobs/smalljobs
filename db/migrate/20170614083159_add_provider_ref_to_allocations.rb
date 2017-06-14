class AddProviderRefToAllocations < ActiveRecord::Migration[5.0]
  class Allocations < ActiveRecord::Base
  end

  def change
    add_reference :allocations, :provider, index: true

    Allocation.all.each do |allocation|
      allocation.update_attributes!(provider_id: allocation.job.provider_id) unless allocation.job.nil?
    end
  end
end
