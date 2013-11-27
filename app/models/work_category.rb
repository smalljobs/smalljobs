class WorkCategory < ActiveRecord::Base
  validates :name, presence: true
end
