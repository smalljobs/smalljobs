class Job < ActiveRecord::Base
  has_and_belongs_to_many :seekers

  belongs_to :provider, inverse_of: :jobs
  belongs_to :work_category, inverse_of: :jobs

  has_one :place, through: :provider

  validates :provider, presence: true
  validates :work_category, presence: true

  validates :state, presence: true, inclusion: { in: lambda { |m| m.state_enum }}

  validates :title, presence: true
  validates :description, presence: true

  validates :date_type, presence: true, inclusion: { in: lambda { |m| m.date_type_enum }}
  validates :start_date, presence: true, if: lambda { |m| ['date', 'date_range'].include?(m.date_type) }
  validates :end_date, presence: true, if: lambda { |m| m.date_type == 'date_range' }

  validates :salary, presence: true, numericality: true
  validates :salary_type, presence: true, inclusion: { in: lambda { |m| m.salary_type_enum }}

  validates :manpower, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 30
  }

  after_create :send_job_created,   if: proc { |s| s.state == 'created' }
  after_save   :send_job_connected, if: proc { |s| s.state_changed? && s.state_was == 'available' && s.state == 'connected' }

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
    %w(created available connected rated)
  end

  # Available salary types
  #
  # @return [Array<String>] list of possible salary types
  #
  def salary_type_enum
    %w(hourly fixed)
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

end
