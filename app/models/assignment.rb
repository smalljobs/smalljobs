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

    return stat + ", " + start_time.strftime("%d.%m.%Y") + ", " + duration.to_s + "h, CHF " + payment.to_s
  end
end
