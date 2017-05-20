class Job < ActiveRecord::Base
  belongs_to :provider, inverse_of: :jobs
  belongs_to :work_category, inverse_of: :jobs
  belongs_to :organization

  has_many :allocations, after_add: :evaluate_state, after_remove: :evaluate_state

  has_many :seekers, through: :allocations

  has_one :place, through: :provider

  has_many :assignments

  has_many :todos

  validates :provider, presence: true
  validates :work_category, presence: true

  validates :organization, presence: true

  validates :state, presence: true, inclusion: { in: lambda { |m| m.state_enum }}

  validates :title, presence: true

  validates :date_type, presence: true, inclusion: { in: lambda { |m| m.date_type_enum }}
  validates :start_date, presence: true, if: lambda { |m| ['date', 'date_range'].include?(m.date_type) }
  validates :end_date, presence: true, if: lambda { |m| m.date_type == 'date_range' }

  validates :salary_type, presence: true, inclusion: { in: lambda { |m| m.salary_type_enum }}
  validates :salary, numericality: true, presence: true, if: lambda {|m| m.salary_type != 'hourly_per_age'}

  validates :manpower, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  after_create :send_job_created,   if: proc { |s| s.state == 'created' }
  after_save   :send_job_connected, if: proc { |s| s.state_changed? && s.state_was == 'available' && s.state == 'connected' }
  before_save :set_state_last_change,   if: proc { |s| s.state_changed?}

  after_save :adjust_todo

  def adjust_todo
    Todo.where(record_type: :job, record_id: id).find_each &:destroy!
    Todotype.job.find_each do |todotype|
      begin
        result = Job.find_by(todotype.where + " AND id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :job, todotype: todotype, job_id: id)
        end
      rescue
        nil
      end
    end
  end

  # scope :without_applications, -> { includes(:applications).where('applications.id IS NULL') }

  # Available date types
  #
  # @return [Array<String>] list of possible dates types
  #
  def date_type_enum
    %w(agreement date date_range)
  end

  # Available status types
  #
  # @return [Array<String>] list of possible job states
  #
  def state_enum
    # %w(created available connected rated)
    %w(hidden public running feedback finished)
  end

  # Available salary types
  #
  # @return [Array<String>] list of possible salary types
  #
  def salary_type_enum
    %w(hourly fixed hourly_per_age)
  end

  # Update the job status when new allocations
  # and reviews arrives
  #
  def evaluate_state(assoc)
    # if self.reviews.count >= self.manpower + 1
    #   self.update_attribute(:state, 'rated')
    #
    # elsif self.allocations.count >= self.manpower
    #   self.update_attribute(:state, 'connected')
    #
    # else
    #   self.update_attribute(:state, 'available')
    # end
  end

  # Sends a notification when a job in the
  # created state is created.
  #
  def send_job_created
    Notifier.job_created_for_broker(self).deliver
  end

  # Sends a notification when a job is connected.
  #
  def send_job_connected
    Notifier.job_connected_for_seekers(self).deliver
    Notifier.job_connected_for_provider(self).deliver
  end

  # Sends rating reminders to the provider and seekers
  # once the job has been done.
  #
  def self.send_rating_reminders
    condition = <<-SQL
      state = 'connected' AND rating_reminder_sent = false AND (
        (date_type = 'date' AND start_date <= :ago) OR
        (date_type = 'date_range' AND end_date <= :ago) OR
        (date_type = 'agreement' AND DATE(updated_at) <= :ago)
      )
    SQL

    Job.where(condition, ago: 2.weeks.ago).find_each do |job|
      Notifier.job_rating_reminder_for_provider(job).deliver
      Notifier.job_rating_reminder_for_seekers(job).deliver
      job.update_attribute(:rating_reminder_sent, true)
    end
  end

  # Sets date of last change of state
  def set_state_last_change
    self.last_change_of_state = DateTime.now()
  end

  def self.state_from_integer(state_int)
    if state_int == 0
      return 'hidden'
    elsif state_int == 1
      return 'public'
    elsif state_int == 2
      return 'running'
    elsif state_int == 3
      return 'feedback'
    elsif state_int == 4
      return 'finished'
    else
      return nil
    end
  end

  def self.state_to_integer(state)
    if state == 'hidden'
      return 0
    elsif state == 'public'
      return 1
    elsif state == 'running'
      return 2
    elsif state == 'feedback'
      return 3
    elsif state == 'finished'
      return 4
    end
  end

end
