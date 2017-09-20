class AddProviderToReview < ActiveRecord::Migration
  def change
    add_reference :reviews, :provider
  end
end
