class Broker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

  # load_and_authorize_resource :job
  # load_and_authorize_resource :allocation, through: :job

  skip_authorize_resource :allocation, only: :new

  actions :all

  def show
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(job_id: @job.id, seeker_id: params[:id])
    if @allocation.nil? && !params[:create].nil?
      @allocation = Allocation.new(provider_id: @job.provider_id, job_id: @job.id, seeker_id: params[:id], state: :proposal)
      @allocation.save!
    end

    @messages = MessagingHelper::get_messages(@allocation.seeker.app_user_id)
  end

  def change_state
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])
    reject_other = params[:reject_other].to_s == 'true'

    if @allocation.application_open?
      @allocation.state = :active
      @allocation.save!
      reject_other_allocations(@job) if reject_other
    elsif @allocation.application_rejected?
      @allocation.state = :active
      @allocation.save!
      reject_other_allocations(@job) if reject_other
    elsif @allocation.proposal?
      @allocation.state = :active
      @allocation.save!
      reject_other_allocations(@job) if reject_other
    elsif @allocation.active?
      @allocation.state = :finished
      @allocation.save!
    elsif @allocation.finished?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.cancelled?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.application_retracted?
      @allocation.state = :active
      @allocation.save!
    end

    render json: { redirect_to: broker_job_allocation_url(@job, @allocation.seeker) }

  end

  def cancel_state
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])

    redirect_to = broker_job_allocation_url(@job, @allocation.seeker)

    if @allocation.application_open?
      @allocation.state = :application_rejected
      @allocation.save!
    elsif @allocation.proposal?
      @allocation.destroy!
    elsif @allocation.active?
      @allocation.state = :cancelled
      @allocation.save!
    end

    render json: {redirect_to: redirect_to}
  end

  def send_message
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])
    seeker = @allocation.seeker
    title = params[:title]
    message = params[:message]
    require 'rest-client'
    dev = 'https://devadmin.jugendarbeit.digital/api/jugendinfo_push/send'
    live = 'https://admin.jugendarbeit.digital/api/jugendinfo_push/send'
    response = RestClient.post dev, api: 'ULv8r9J7Hqc7n2B8qYmfQewzerhV9p', message_title: title, message: message, device_token: @allocation.seeker.app_user_id, sendermail: current_broker.email
    json = JSON.parse(response.body)
    # conv_id = json['conversation_id']
    # @allocation.conversation_id = conv_id
    # @allocation.save!

    render json: {state: 'ok', response: response}
  end

  protected

  def reject_other_allocations(job)
    job.allocations.application_open.find_each do |allocation|
      allocation.state = :application_rejected
      allocation.save!
    end
  end

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
