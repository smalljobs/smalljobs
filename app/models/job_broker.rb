class JobBroker < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :employments, inverse_of: :job_broker
  has_many :organizations, through: :employments
  has_many :regions, through: :employments

  validates :firstname, :lastname, :phone, presence: true
  validates :phone, :mobile, phony_plausible: true

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  def active_for_authentication?
    super && active?
  end

  def name
    "#{ firstname } #{ lastname }"
  end
end
