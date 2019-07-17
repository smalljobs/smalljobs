class Organization < ActiveRecord::Base
  has_many :employments, inverse_of: :organization
  has_many :brokers, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions

  belongs_to :place, inverse_of: :organization

  validates :name, presence: true, uniqueness: true
  validates :website, url: true, allow_blank: true, allow_nil: true

  validates :street, :place, presence: true

  validates :email, email: true, presence: true
  validates :phone, phony_plausible: true, allow_blank: true, allow_nil: true
  validate :vacation_date
  # validates :default_hourly_per_age, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :random, -> {order('RANDOM()')}
  scope :active, -> {where(active: true)}

  phony_normalize :phone, default_country_code: 'CH'

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader

  before_save :destroy_logo?
  before_save :destroy_background?

  after_initialize :copy_default_templates

  after_create :connect_to_region
  attr_accessor :assigned_to_region, :region_id

  def connect_to_region
    if assigned_to_region == 'true'
      employment = Employment.new(organization_id: self.id, region_id: region_id)
      employment.assigned_only_to_region = true
      employment.save
    end
  end

  def copy_default_templates
    template_names = ['welcome_letter_employers_msg', 'welcome_app_register_msg', 'welcome_chat_register_msg',
                      'not_receive_job_msg', 'get_job_msg', 'activation_msg', 'welcome_email_for_parents_msg']
    DefaultTemplate.where(template_name: template_names).each do |default_template|
      template_name = default_template.template_name
      self[template_name] = default_template.template if self[template_name].blank?
    end
  end

  def logo_delete
    @logo_delete ||= "0"
  end

  def logo_delete=(value)
    @logo_delete = value
  end

  def background_delete
    @background_delete ||= "0"
  end

  def background_delete=(value)
    @background_delete = value
  end

  private

  def destroy_logo?
    self.remove_logo! if @logo_delete == "1"
  end

  def destroy_background?
    self.remove_background! if @background_delete == "1"
  end

  private

  def vacation_date
    if vacation_active
      if start_vacation_date.present? ^ end_vacation_date.present?
        errors.add(:base, I18n.t('errors.messages.start_and_end_date'))
      end
      if [start_vacation_date, end_vacation_date].all?(&:present?) && (start_vacation_date>=end_vacation_date)
        errors.add(:start_vacation_date, I18n.t('errors.messages.start_date_too_late'))
      end
      if end_vacation_date.present? && (end_vacation_date < Date.today)
        errors.add(:end_vacation_date, I18n.t('errors.messages.end_date_too_early'))
      end
    end
  end
end
