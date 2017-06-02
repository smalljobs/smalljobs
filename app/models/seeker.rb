class Seeker < ActiveRecord::Base

  devise :database_authenticatable, :registerable, authentication_keys: [:login]

  # include ConfirmToggle

  enum status: {inactive: 1, active: 2, completed: 3}

  has_and_belongs_to_many :work_categories
  has_and_belongs_to_many :certificates

  has_many :allocations, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :access_tokens, dependent: :destroy

  has_many :jobs, through: :allocations

  has_many :todos

  belongs_to :place, inverse_of: :seekers
  belongs_to :organization

  validates :login, presence: true, uniqueness: true

  validates :firstname, :lastname, presence: true

  validates :street, :place, presence: true

  validates :organization, presence: true

  validates :mobile, phony_plausible: true, presence: true

  validates :date_of_birth, presence: true
  validates :sex, inclusion: {in: lambda {|m| m.sex_enum}}

  validates :contact_preference, inclusion: {in: lambda {|m| m.contact_preference_enum}}
  validates :contact_availability, presence: true, if: lambda {%w(phone mobile).include?(self.contact_preference)}

  phony_normalize :phone, default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  validate :ensure_seeker_age

  after_save :send_to_jugendinfo

  after_save :adjust_todo

  def adjust_todo
    Todo.where(record_type: :seeker, record_id: id).find_each &:destroy!
    Todotype.seeker.find_each do |todotype|
      begin
        result = Seeker.find_by(todotype.where + " AND id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :seeker, todotype: todotype, seeker_id: id)
        end
      rescue
        nil
      end
    end
  end

  # validate :ensure_work_category

  # validates_acceptance_of :terms, allow_nil: false, on: :create

  # after_save :send_agreement_email,    if: proc { |s| s.confirmed_at_changed? && s.confirmed_at_was.nil? }
  # after_save :send_registration_email, if: proc { |s| s.confirmed_at_changed? && s.confirmed_at_was.nil? }

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{ firstname } #{ lastname }"
  end

  # Available options for the sex
  #
  # @return [Array<String>] the possible seeker sex
  #
  def sex_enum
    %w(male female other)
  end

  # Available options for the contact preference
  #
  # @return [Array<String>] the possible seeker contact preferences
  #
  def contact_preference_enum
    %w(email phone mobile postal whatsapp)
  end

  # @!group Devise

  # Check if the user can log in
  #
  # @return [Boolean] the status
  #
  def active_for_authentication?
    super && active?
  end

  # Return the I18n message key when authentication fails
  #
  # @return [Symbol] the i18n key
  #
  def unauthenticated_message
    confirmed? ? :inactive : :unconfirmed
  end

  # @!endgroup

  private

  # Validate the job seeker age
  #
  # @return [Boolean] validation status
  #
  def ensure_seeker_age
    if date_of_birth.present? && !date_of_birth.between?(26.years.ago, 13.years.ago)
      errors.add(:date_of_birth, :invalid_seeker_age)
    end
  end

  # Ensure a seeker has at least one work category selected
  #
  # @return [Boolean] validation status
  #
  def ensure_work_category
    if work_categories.empty?
      errors.add(:work_categories, :invalid_work_category)
    end
  end

  # Send the seeker a welcome email
  # with the agreement pdf to sign and return.
  #
  def send_agreement_email
    Notifier.send_agreement_for_seeker(self).deliver
  end

  # Send the broker an email about the new seeker.
  #
  def send_registration_email
    Notifier.new_seeker_signup_for_broker(self).deliver
  end

  # Make post request to jugendinfo API
  def send_to_jugendinfo
    require 'rest-client'
    dev = 'http://devadmin.jugendarbeit.digital/api/jugendinfo_user/update_data/'
    live = 'http://admin.jugendarbeit.digital/api/jugendinfo_user/update_data/'
    RestClient.post dev, {token: '1bN1SO2W1Ilz4xL2ld364qVibI0PsfEYcKZRH', id: app_user_id, smalljobs_user_id: id, firstname: firstname, lastname: lastname, mobile: mobile, address: street, zip: place.zip, birthdate: date_of_birth.strftime('%Y-%m-%d'), city: place.name, smalljobs_status: Seeker.statuses[status]}
  end

end
