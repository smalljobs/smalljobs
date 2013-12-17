class JobProvider < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, authentication_keys: [:username]

  before_save :nullify_blank_email

  validates :username, presence: true, uniqueness: true
  validates :firstname, :lastname, presence: true

  validates :street, :zip, :city, presence: true
  validates :zip, postal_code: { country: :ch }

  validates :email, email: true, allow_blank: true, allow_nil: true
  validates :phone, :mobile, phony_plausible: true

  validates :contact_preference, inclusion: { in: lambda { |m| m.contact_preference_enum } }
  validates :contact_availability, presence: true, if: lambda { %w(phone mobile).include?(self.contact_preference) }

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  def email_required?
    false
  end

  def unauthenticated_message
    confirmed? ? :inactive : :unconfirmed
  end

  def active_for_authentication?
    super && active?
  end

  def contact_preference_enum
    %w(email phone mobile postal)
  end

  def name
    "#{ firstname } #{ lastname }"
  end

  def inactive_message
    if !confirmed?
      self.email.blank? ? :unconfirmed_manual : :unconfirmed
    else
      super
    end
  end

  protected

  def nullify_blank_email
    self.email = nil if self.email.blank?
  end

end
