class JobBroker < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_and_belongs_to_many :organizations

  validates :firstname, :lastname, :phone, presence: true
  validates :phone, :mobile, phony_plausible: true

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  def active_for_authentication?
    super && active?
  end
end
