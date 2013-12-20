class Employment < ActiveRecord::Base
  belongs_to :organization, inverse_of: :employments
  belongs_to :broker, inverse_of: :employments
  belongs_to :region, inverse_of: :employments

  validates :organization, :broker, :region, presence: true

  def name
    "#{ self.organization.try(:name) }, #{ self.region.try(:name) }"
  end
end
