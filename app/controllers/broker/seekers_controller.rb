class Broker::SeekersController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]
  before_filter :optional_password, only: [:update]
  before_filter :redirect_smalljobs, only: [:agreement]

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

  def update
    if @seeker.update(permitted_params[:seeker])
      redirect_to [:broker, @seeker]
    else
      @jobs_certificate = @seeker.jobs_certificate
      @organizations_and_regions = Region.order(:name).includes(:organizations).map{|x| [x.name, x.organizations.order(:name).distinct.map{|y|  [y.name, y.id]}]}
      @messages = MessagingHelper::get_messages(current_broker.rc_id, @seeker.rc_username)
      rc = RocketChat::Users.new
      @seeker_exist_in_chat = rc.info(@seeker.rc_id).present?
      render :edit
    end
  end

  def edit
    @jobs_certificate = @seeker.jobs_certificate
    @organizations_and_regions = Region.order(:name).includes(:organizations).map{|x| [x.name, x.organizations.order(:name).distinct.map{|y|  [y.name, y.id]}]}
    @messages = MessagingHelper::get_messages(current_broker.rc_id, @seeker.rc_username)
    rc = RocketChat::Users.new
    @seeker_exist_in_chat = rc.info(@seeker.rc_id).present?
    # @seeker.current_broker_id = current_broker.id
    edit!
  end

  # Renders seeker agreement as pdf file
  #
  def agreement
    @seeker = Seeker.find_by(agreement_id: params[:agreement_id])
    render pdf: 'Einverständnis', template: 'broker/seekers/agreement.html.erb', margin: {top: 0, left: 0, right: 0, bottom: 0}
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
    default_rc_user = @seeker.organization.broker
    Spawnling.new do
      response = MessagingHelper::send_message(@seeker.rc_id, default_rc_user.rc_username, "#{title}. #{message}")
    end
    render json: { state: 'ok'}#, response: response }
  end

  # Adds new comment for seeker
  #
  def add_comment
    comment = params[:comment]
    Note.create!(seeker_id: @seeker.id, broker_id: current_broker.id, message: comment)
  end

  # Remove broker comment from seeker
  #
  def remove_comment
    id = params[:note_id]
    note = Note.find_by(id: id)
    if note.nil? || note.broker.id != current_broker.id || note.seeker.id != @seeker.id
      return
    end

    note.destroy!
  end


  def update_comment
    note = Note.find_by(id: params[:note_id], broker_id: current_broker.id, seeker_id: @seeker.id)
    respond_to do |format|
      if note&.update(message: params[:message])
        format.json {
          render json: {
            message: note.message,
            updated_at: note.updated_at.strftime("%d.%m.%Y, %H:%M")
          }, status: 200
        }
      else
        format.json {
          render json: {
            error: "Wir können eine Notiz nicht aktualisieren"
          }, status: 422}
      end
    end
  end


  # Update organization and change status if change region
  #
  def update_organization
    respond_to do |format|
      if @seeker.update_organization(permitted_organization_params[:seeker][:organization_id])
        format.json { render json: {}, status: :ok}
      else
        format.json { render json: { error: @seeker.errors.full_messages}, status: :unprocessable_entity}
      end
    end
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
    params.permit(seeker: [:occupation, :occupation_end_date, :additional_contacts, :languages, :id, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :sex, :email, :phone, :mobile, :date_of_birth, :contact_preference, :contact_availability, :active, :confirmed, :terms, :status, :organization_id, :notes, :discussion, :parental, :other_skills, work_category_ids: [], certificate_ids: []])
  end

    def permitted_organization_params
      params.permit(seeker: [:organization_id])
    end


    def redirect_smalljobs
    if request.subdomain == 'smalljobs'
      redirect_to "https://winterthur.smalljobs.ch#{request.fullpath}", :status => :moved_permanently
    end
  end

end
