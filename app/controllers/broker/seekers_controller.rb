class Broker::SeekersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :seeker, through: :current_region, except: :new

  def index
    redirect_to broker_dashboard_url + "#seekers"
  end

  def show
    redirect_to request.referer
  end

  def create
    @seeker = Seeker.new(permitted_params[:seeker])
    @seeker.login = @seeker.mobile

    create!
  end

  def agreement
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Einverständnis", template: 'broker/seekers/agreement.html.erb'
      end
    end
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
    params.permit(seeker: [:id, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :sex, :email, :phone, :mobile, :date_of_birth, :contact_preference, :contact_availability, :active, :confirmed, :terms, :status, :organization_id, :notes, :discussion, :parental, work_category_ids: []])
  end

end
