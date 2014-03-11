class Broker::SeekersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :seeker, through: :current_region, except: :new

  def create
    @seeker = Seeker.new(permitted_params[:seeker])
    @seeker.terms = '1'

    create!
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
    params.permit(seeker: [:id, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :email, :phone, :mobile, :date_of_birth, :contact_preference, :contact_availability, :active, :confirmed, :terms, work_category_ids: []])
  end

end
