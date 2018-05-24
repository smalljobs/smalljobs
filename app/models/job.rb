class Job < ActiveRecord::Base
  belongs_to :provider, inverse_of: :jobs
  belongs_to :work_category, inverse_of: :jobs
  belongs_to :organization

  has_many :allocations, after_add: :evaluate_state, after_remove: :evaluate_state

  has_many :seekers, through: :allocations

  has_one :place, through: :provider

  has_many :assignments

  # has_many :notes

  has_many :todos

  attr_accessor :new_note
  attr_accessor :current_broker_id

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

  before_save :set_state_last_change, if: proc { |s| s.state_changed?}

  after_save :adjust_todo
  after_save :cancel_applications_if_finished

  after_save :add_new_note
  after_save :send_request_refresh

  def add_new_note
    return unless new_note.present?

    Note.create!(job_id: id, broker_id: current_broker_id, message: new_note)
  end

  def adjust_todo
    Todo.where(record_type: :job, record_id: id).find_each &:destroy!
    Todotype.job.find_each do |todotype|
      begin
        result = Job.left_outer_joins(:allocations).find_by(todotype.where + " AND jobs.id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :job, todotype: todotype, job_id: id)
        end
      rescue
        nil
      end
    end
  end


  # If job is in finished state all open applications should be cancelled
  #
  def cancel_applications_if_finished
    return unless state == 'finished'

    self.allocations.where(state: :application_open).or(self.allocations.where(state: :active)).find_each do |allocation|
      allocation.state = :cancelled
      allocation.save
    end
  end

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
    %w(hidden public check feedback finished)
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
      return 'check'
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
    elsif state == 'check'
      return 2
    elsif state == 'feedback'
      return 3
    elsif state == 'finished'
      return 4
    end
  end

  # Make post to jugendarbeit requesting user in app to refresh job list
  #
  def send_request_refresh
    require 'rest-client'
    dev = 'https://devadmin.jugendarbeit.digital/api/jugendinfo_smalljobs/refresh/'
    live = 'https://admin.jugendarbeit.digital/api/jugendinfo_smalljobs/refresh/'
    begin
      logger.info "Sending changes to jugendinfo"
      self.organization.regions.each do |region|
        logger.info "Sending: #{{token: '1bN1SO2W1Ilz4xL2ld364qVibI0PsfEYcKZRH', region_id: region.id}}"
        response = RestClient.post dev, {token: '1bN1SO2W1Ilz4xL2ld364qVibI0PsfEYcKZRH', region_id: region.id}
        logger.info "Response from jugendinfo: #{response}"
      end
    rescue
      logger.info "Failed sending changes to jugendinfo"
      nil
    end
  end

  public

  def stat_name
    if state == "finished"
      return "finished"
    end

    return "active"
  end
end
