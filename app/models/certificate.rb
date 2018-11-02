class Certificate < ActiveRecord::Base
  has_and_belongs_to_many :seekers

  validates :title, presence: true
end
