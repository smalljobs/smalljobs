require 'subdomain_validator'

class Region < ActiveRecord::Base
  has_many :places, inverse_of: :region
  has_many :jobs, through: :places

  has_many :employments, inverse_of: :region
  has_many :brokers, through: :employments
  has_many :organizations, through: :employments

  has_many :providers, through: :places
  has_many :seekers, through: :places

  belongs_to :country

  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, subdomain: true
  validates :places, length: {minimum: 1}

  before_validation :iframe_responsive

  mount_uploader :logo, LogoUploader
  mount_uploader :header_image, HeaderImageUploader


  def iframe_responsive
    content_nokogiri = Nokogiri::HTML.fragment(self.content)
    contact_content_nokogiri = Nokogiri::HTML.fragment(self.contact_content)
    content_nokogiri.css("iframe").each do |el|
      if el['width'] or el['height']
        el.delete('width')
        el.delete('height')
        el["class"] = "embed-responsive-item before-save"
      end
    end
    content_nokogiri.css('.embed-responsive-item.before-save').wrap("<div class='embed-responsive embed-responsive-16by9'></div>")
    content_nokogiri.css('.embed-responsive-item.before-save').each do |el|
      el["class"] = "embed-responsive-item"
    end
    self.content = content_nokogiri.to_html

    contact_content_nokogiri.css("iframe").each do |el|
      if el['width'] or el['height']
        el.delete('width')
        el.delete('height')
        el["class"] = "embed-responsive-item before-save"
      end
    end
    contact_content_nokogiri.css('.embed-responsive-item.before-save').wrap("<div class='embed-responsive embed-responsive-16by9'></div>")
    contact_content_nokogiri.css('.embed-responsive-item.before-save').each do |el|
      el["class"] = "embed-responsive-item"
    end
    self.contact_content = contact_content_nokogiri.to_html
  end
end
