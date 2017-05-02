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
      @allocation = Allocation.new(job_id: @job.id, seeker_id: params[:id], state: :proposal)
      @allocation.save!
    end

    require 'rest-client'

    if !@allocation.nil? && @allocation.conversation_id.nil?
      dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_message/get_conversation_id_by_user?user_id=#{@allocation.seeker.app_user_id}"
      live = "https://admin.jugendarbeit.digital/api/jugendinfo_message/get_conversation_id_by_user?user_id=#{@allocation.seeker.app_user_id}"
      response = RestClient.get dev
      json = JSON.parse(response)
      @allocation.conversation_id = json['id']
      @allocation.save!
    end


    if !@allocation.nil? && !@allocation.conversation_id.nil?
      dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{@allocation.conversation_id}&limit=1000"
      live = "https://admin.jugendarbeit.digital/api/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{@allocation.conversation_id}&limit=1000"
      response = RestClient.get dev
      json = JSON.parse(response.body)
      @messages = json['messages'].sort_by {|val| DateTime.strptime(val['datetime'], '%s')}.reverse
    else
      @messages = []
    end
  end

  def change_state
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])

    if @allocation.application_open?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.application_rejected?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.proposal?
      @allocation.state = :active
      @allocation.save!
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

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
