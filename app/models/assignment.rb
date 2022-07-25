class Assignment < ActiveRecord::Base
  belongs_to :seeker
  belongs_to :provider
  belongs_to :job

  validates :provider, presence: true
  validates :seeker, presence: true

  enum status: [:active, :finished]

  before_save :set_start

  # Sets start time if not provided
  def set_start
    self.start_time = DateTime.now if start_time.nil?
  end

  def description
    stat = "Aktiv"
    if self.finished?
      stat = "Beendet"
    end

    date = start_time.present? ? start_time.strftime("%d.%m.%Y") : ''
    dur = ''

    unless duration.nil?
      minutes = duration/60000
      minutes = minutes.floor
      hours = minutes/60
      hours = hours.floor
      minutes = minutes % 60
      dur = "#{hours}:#{minutes}"
    end

    return "#{stat}, #{date}, #{dur}, #{currency} #{payment}"
  end

  def currency
    country = nil
    begin
      country = self.job.region.country
    rescue StandardError => e
      Raven.extra_context(assignment_id: self.id) do
        Raven.capture_exception(e)
      end
    end
    return 'CHF' if country.blank?
    return 'EUR' if country.name.downcase == 'Germany' || country.alpha2.downcase == 'de'

    'CHF'
  end
end
