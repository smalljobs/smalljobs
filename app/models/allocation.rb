class Allocation < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker
  belongs_to :provider

  enum state: [:application_open, :application_rejected, :proposal, :active, :finished]

  validates :job, presence: true
  validates :seeker, presence: true
  validates :seeker, uniqueness: { scope: :job_id }, if: Proc.new { |p| p.job && p.seeker }

  def name
    "#{ seeker.try(:name) } #{ job.try(:title) }"
  end
end
