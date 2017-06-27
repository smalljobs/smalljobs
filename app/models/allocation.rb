class Allocation < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker
  belongs_to :provider

  has_many :todos

  enum state: {application_open: 0, application_rejected: 1, proposal: 2, active: 3, finished: 4, cancelled: 5, application_retracted: 6}

  validates :job, presence: true
  validates :seeker, presence: true
  validates :seeker, uniqueness: { scope: :job_id }, if: proc { |p| p.job && p.seeker }

  before_save :set_state_last_change, if: proc { |s| s.state_changed?}

  after_save :adjust_todo

  def adjust_todo
    Todo.where(record_type: :allocation, record_id: id).find_each &:destroy!
    Todotype.allocation.find_each do |todotype|
      begin
        result = Allocation.joins(:seeker, job: :provider).find_by(Allocation.replace_state_with_number(todotype.where) + " AND allocations.id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :allocation, todotype: todotype, allocation_id: id, seeker_id: seeker_id, job_id: job_id, provider_id: job.provider_id)
        end
      rescue
        nil
      end
    end
  end

  def self.replace_state_with_number(string)
    new_str = string
    states = {application_open: 0, application_rejected: 1, proposal: 2, active: 3, finished: 4, cancelled: 5, application_retracted: 6}
    states.each do |name, number|
      new_str = new_str.gsub(name.to_s, number.to_s)
    end

    new_str
  end

  def name
    "#{seeker.try(:name)} #{job.try(:title)}"
  end

  # Sets date of last change of state
  def set_state_last_change
    self.last_change_of_state = DateTime.now()
  end
end
