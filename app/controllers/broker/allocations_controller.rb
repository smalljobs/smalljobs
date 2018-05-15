class Broker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

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

    job_provider_phone = @job.provider.mobile.empty? ? @job.provider.phone : @job.provider.mobile
    @get_job_msg = Mustache.render(@job.provider.organization.get_job_msg, seeker_first_name: @allocation.seeker.firstname, seeker_last_name: @allocation.seeker.lastname, seeker_link_to_agreement: url_for(agreement_broker_seeker_url(@allocation.seeker)), provider_first_name: @job.provider.firstname, provider_last_name: @job.provider.lastname, provider_phone: job_provider_phone, broker_first_name: current_broker.firstname, broker_last_name: current_broker.lastname, organization_name: @job.provider.organization.name, organization_zip: @job.provider.organization.place.zip, organization_street: @job.provider.organization.street, organization_place: @job.provider.organization.places.first.name, organization_phone: @job.provider.organization.phone, organization_email: @job.provider.organization.email, link_to_jobboard_list: url_for(root_url()))
    @get_job_msg.gsub! "\n", "<br>"
    @not_receive_job_msg = Mustache.render(@job.provider.organization.not_receive_job_msg, seeker_first_name: @allocation.seeker.firstname, seeker_last_name: @allocation.seeker.lastname, seeker_link_to_agreement: url_for(agreement_broker_seeker_url(@allocation.seeker)), provider_first_name: @job.provider.firstname, provider_last_name: @job.provider.lastname, provider_phone: job_provider_phone, broker_first_name: current_broker.firstname, broker_last_name: current_broker.lastname, organization_name: @job.provider.organization.name, organization_zip: @job.provider.organization.place.zip, organization_street: @job.provider.organization.street, organization_place: @job.provider.organization.places.first.name, organization_phone: @job.provider.organization.phone, organization_email: @job.provider.organization.email, link_to_jobboard_list: url_for(root_url()))
    @not_receive_job_msg.gsub! "\n", "<br>"
  end

  # Changes state of allocation to the next one
  #
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

  # Changes allocation accordingly to user cancelling allocation action
  #
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

  # Sends given message to the seeker (via mobile application)
  #
  def send_message
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])
    seeker = @allocation.seeker
    title = params[:title]
    message = params[:message]

    response = MessagingHelper::send_message(title, message, seeker.app_user_id, current_broker.email)

    render json: {state: 'ok', response: response}
  end

  protected

  # Changes states of all open allocations for given job to application_rejected
  #
  # @param job [Job]
  #
  def reject_other_allocations(job)
    job.allocations.application_open.find_each do |allocation|
      allocation.state = :application_rejected
      allocation.save!
    end
  end

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
