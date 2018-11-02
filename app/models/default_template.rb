class DefaultTemplate < ActiveRecord::Base
  validates :template_name, presence: true, uniqueness: true
  validates :template, presence: true
end