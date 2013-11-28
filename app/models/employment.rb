class Employment < ActiveRecord::Base
  belongs_to :organization, inverse_of: :employments
  belongs_to :job_broker, inverse_of: :employments
  belongs_to :region, inverse_of: :employments

  validates :organization, :job_broker, :region, presence: true

  def name
    "#{ self.organization.name }, #{ self.region.name }"
  end
end
