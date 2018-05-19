class WorkCategory < ActiveRecord::Base
  has_and_belongs_to_many :seekers
  has_many :jobs

  validates :name, presence: true

  def label
    "<i class='fa fa-#{icon_name} work-category-icon'></i>#{name}".html_safe
  end
end
