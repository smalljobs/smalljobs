class Broker::SeekersController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :seeker, through: :current_region, except: [:new, :agreement]

  def index
    redirect_to broker_dashboard_url + "#seekers"
  end

  def show
    redirect_to request.referer
  end

  def new
    @seeker = Seeker.new()
    @seeker.place = current_region.places.order(:name, :zip).first
  end

  def create
    @seeker = Seeker.new(permitted_params[:seeker])
    @seeker.login = @seeker.mobile

    create!
  end

  def edit
    dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_message/get_conversation_id_by_user?user_id=#{@seeker.app_user_id}"
    live = "https://admin.jugendarbeit.digital/api/jugendinfo_message/get_conversation_id_by_user?user_id=#{@seeker.app_user_id}"
    response = RestClient.get live
    json = JSON.parse(response)
    conversation_id = json['id']
    if conversation_id != nil
      dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{conversation_id}&limit=1000"
      live = "https://admin.jugendarbeit.digital/api/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{conversation_id}&limit=1000"
      response = RestClient.get live
      json = JSON.parse(response.body)
      @messages = json['messages'].sort_by {|val| DateTime.strptime(val['datetime'], '%s')}.reverse
    else
      @messages = []
    end


    edit!
  end

  def agreement
    @seeker = Seeker.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Einverständnis", template: 'broker/seekers/agreement.html.erb'
      end
    end
  end

  def delete
    Allocation.where(seeker_id: @seeker.id).find_each do |allocation|
      allocation.destroy!
    end

    Assignment.where(seeker_id: @seeker.id).find_each do |assignment|
      assignment.destroy!
    end

    @seeker.destroy!

    render json: {message: 'Seeker deleted'}, status: 200
  end

  def send_message
    seeker = Seeker.find_by(id: params[:id])
    title = params[:title]
    message = params[:message]
    require 'rest-client'
    dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_push/send"
    live = "https://admin.jugendarbeit.digital/api/jugendinfo_push/send"
    response = RestClient.post live, {api: 'ULv8r9J7Hqc7n2B8qYmfQewzerhV9p', message_title: title, message: message, device_token: @seeker.app_user_id, sendermail: current_broker.email}
    json = JSON.parse(response.body)
    conv_id = json['conversation_id']

    render json: {state: 'ok', response: response}
  end

  protected

  def current_user
    current_broker
  end

  def optional_password
    if params[:seeker][:password].blank?
      params[:seeker].delete(:password)
      params[:seeker].delete(:password_confirmation)
    end
  end

  def permitted_params
    params.permit(seeker: [:id, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :sex, :email, :phone, :mobile, :date_of_birth, :contact_preference, :contact_availability, :active, :confirmed, :terms, :status, :organization_id, :notes, :discussion, :parental, work_category_ids: [], certificate_ids: []])
  end

end
