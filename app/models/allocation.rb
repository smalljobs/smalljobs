class Allocation < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker
  belongs_to :provider

  enum state: [:application_open, :application_rejected, :proposal, :active, :finished, :cancelled]

  validates :job, presence: true
  validates :seeker, presence: true
  validates :seeker, uniqueness: { scope: :job_id }, if: Proc.new { |p| p.job && p.seeker }

  before_save :set_state_last_change,   if: proc { |s| s.state_changed?}

  def name
    "#{ seeker.try(:name) } #{ job.try(:title) }"
  end

  # Sets date of last change of state
  def set_state_last_change
    self.last_change_of_state = DateTime.now()
  end
end
