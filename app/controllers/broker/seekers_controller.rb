class Broker::SeekersController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :seeker, through: :current_region, except: [:new, :agreement]

  def index
    redirect_to broker_dashboard_url + '#seekers'
  end

  def show
    redirect_to edit_broker_seeker_path(@seeker)
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
    @messages = MessagingHelper::get_messages(@seeker.app_user_id)
    @seeker.current_broker = current_broker
    edit!
  end

  # Renders seeker agreement as pdf file
  #
  def agreement
    @seeker = Seeker.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Einverständnis', template: 'broker/seekers/agreement.html.erb', margin: {top: 3, left: 3, right: 3, bottom: 3}
      end
    end
  end

  def delete
    Todo.where(seeker_id: @seeker.id).find_each(&:destroy!)

    Allocation.where(seeker_id: @seeker.id).find_each(&:destroy!)

    Assignment.where(seeker_id: @seeker.id).find_each(&:destroy!)

    @seeker.destroy!

    render json: {message: 'Seeker deleted'}, status: 200
  end

  # Sends message to seeker (via mobile application)
  #
  def send_message
    title = params[:title]
    message = params[:message]
    response = MessagingHelper::send_message(title, message, @seeker.app_user_id, current_broker.email)
    render json: { state: 'ok', response: response }
  end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def optional_password
    return unless params[:seeker][:password].blank?
    params[:seeker].delete(:password)
    params[:seeker].delete(:password_confirmation)
  end

  def permitted_params
    params.permit(seeker: [:new_note, :occupation, :occupation_end_date, :additional_contacts, :languages, :id, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :sex, :email, :phone, :mobile, :date_of_birth, :contact_preference, :contact_availability, :active, :confirmed, :terms, :status, :organization_id, :notes, :discussion, :parental, work_category_ids: [], certificate_ids: []])
  end

end
