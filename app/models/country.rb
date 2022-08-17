class Country < ActiveRecord::Base
  has_many :regions
  has_many :places

  validates :name, presence: true

  default_scope { includes(:regions, :places) }
end
