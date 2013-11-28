class Region < ActiveRecord::Base
  has_many :places

  has_many :employments, inverse_of: :region
  has_many :job_brokers, through: :employments
  has_many :organizations, through: :employments

  validates :name, presence: true, uniqueness: true
  validates :places, length: { minimum: 1 }
end
