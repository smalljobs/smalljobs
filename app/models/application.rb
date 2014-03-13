class Application < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker

  validates :job, presence: true
  validates :seeker, presence: true
  validates :seeker, uniqueness: { scope: :job_id }, if: Proc.new { |p| p.job && p.seeker }

  def name
    "#{ seeker.try(:name) } #{ job.try(:title) }"
  end

end
