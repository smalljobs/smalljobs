class Employment < ActiveRecord::Base
  belongs_to :organization, inverse_of: :employments
  belongs_to :broker, inverse_of: :employments
  belongs_to :region, inverse_of: :employments

  attr_accessor :assigned_only_to_region

  validates :organization, presence: true, unless: :assigned_only_to_region?
  validates :broker, presence: true, unless: :assigned_only_to_region?
  validates :region, presence: true

  def assigned_only_to_region?
    assigned_only_to_region
  end

  def name
    "#{organization.try(:name)}, #{region.try(:name)}"
  end
end
