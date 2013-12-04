class JobSeeker < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook]

  has_and_belongs_to_many :work_categories

  validates :firstname, :lastname, presence: true

  validates :street, :zip, :city, presence: true
  validates :zip, postal_code: { country: :ch }

  validates :email, email: true
  validates :phone, :mobile, phony_plausible: true

  validates :date_of_birth, presence: true

  validates :contact_preference, inclusion: { in: lambda { |m| m.contact_preference_enum } }
  validates :contact_availability, presence: true, if: lambda { %w(phone mobile).include?(self.contact_preference) }

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  validate :ensure_seeker_age
  validate :ensure_work_category

  def active_for_authentication?
    super && active?
  end

  def contact_preference_enum
    %w(email phone mobile postal whatsapp)
  end

  def name
    "#{ firstname } #{ lastname }"
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = JobSeeker.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = JobSeeker.new(
        firstname: auth.extra.raw_info.first_name,
        lastname:  auth.extra.raw_info.last_name,
        provider:  auth.provider,
        uid:       auth.uid,
        email:     auth.info.email,
        password:  Devise.friendly_token[0,20]
      )
      user.save(validate: false)
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |seeker|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        seeker.email     = data['email']
        seeker.firstname = data['first_name']
        seeker.lastname  = data['last_name']
      end
    end
  end

  private

  def ensure_seeker_age
    if date_of_birth.present? && !date_of_birth.between?(19.years.ago, 13.years.ago)
      errors.add(:date_of_birth, :invalid_seeker_age)
    end
  end

  def ensure_work_category
    if work_categories.size == 0
      errors.add(:work_categories, :invalid_work_category)
    end
  end

end
