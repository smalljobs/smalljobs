require 'subdomain_validator'

class Region < ActiveRecord::Base
  has_many :places, inverse_of: :region

  has_many :employments, inverse_of: :region
  has_many :brokers, through: :employments
  has_many :organizations, through: :employments

  has_many :providers, through: :places
  has_many :seekers, through: :places

  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, subdomain: true
  validates :places, length: { minimum: 1 }
end
