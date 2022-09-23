class Api::V1::Admin::SeekersController < Api::V1::Admin::ApiController
  before_action :set_seeker_by_phone_or_id, only: [:show]
  before_action :set_seeker, only: [:destroy, :update]
  before_action :set_user_via_phone, only: [:create_seekers_access_token]

  # POST /api/v1/admin/users/login
  # Performs the login.
  # Returns a access_token which is passed along as a header with all future requests to authenticate the user.
  # You must provide the Authorization: Bearer {access_token} header in all other requests.
  # Access tokens are tied to the user who logs in. Tokens are only valid for 30 days.
  #
  def login
    email, password = params[:email], params[:password]

    admin = Admin.find_by(email: email)
    return render json: {code: 'users/not_found', message: 'User not found'}, status: 404 if admin == nil
    return render json: {code: 'users/invalid', message: 'Invalid phone or password'}, status: 422 if !admin.valid_password?(password)

    AccessToken.find_by(userable_id: admin.id, userable_type: 'Admin')&.destroy
    token = AccessToken.new(userable_id: admin.id, userable_type: 'Admin', token_type: 'bearer')
    token.expire_at = DateTime.now() + 30.years
    token.save!

    render json: {
        access_token: token.access_token,
        token_type: token.token_type,
        expires_in: token.expire_at.strftime('%s'),
        created_at: token.created_at,
        refresh_token: token.refresh_token,
      }, status: 200
  end



  # POST /api/v1/admin/users/
  # Register new user.
  # By default, new users have status: status = 1.
  def create
    user_params = register_params

    render(json: {code: 'users/invalid', message: 'Birthdate not present'}, status: 422) && return if user_params[:birthdate] == nil

    user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s').in_time_zone('Warsaw')
    user_params.except!(:birthdate)
    # user_params[:login] = user_params[:phone]
    if user_params[:mobile].blank?
      user_params[:mobile] = user_params[:phone]
    end

    user_params[:work_category_ids] = JSON.parse user_params[:categories] if user_params[:categories] != nil
      # user_params.except!(:categories)

    user_params[:password_confirmation] = user_params[:password]

    unless user_params[:zip].nil?
      place_id = ApiHelper.zip_to_place_id(user_params[:zip])
      if place_id.nil?
        render json: {code: 'users/invalid', message: 'Ungültige Postleitzahl'}, status: 422
        return
      end

      user_params[:place_id] = place_id
      user_params.except!(:zip)
    end


    if user_params[:parent_email].blank?
      parents_email = user_params[:parents_email]
      user_params.except!(:parents_email)
      user_params[:parent_email] = parents_email
    end

    seeker = Seeker.new(user_params)
    seeker.status = 'inactive'
    seeker.ji_request = true
    render(json: {code: 'users/invalid', message: seeker.errors.first}, status: 422) && return if !seeker.save

    if seeker.place.nil?
      seeker.place = seeker.organization.place
      seeker.save
    end

    render json: {message: 'User created successfully', user: ApiHelper::seeker_to_json(seeker), organization: ApiHelper::organization_to_json(seeker.organization, seeker.organization.regions.first.id)}
  end

  # GET /api/v1/admin/users
  # Returns list of users.
  # Optioneally you can retrieve list of users from defined organization.
  def index
    users = []
    organization_id = params[:organization_id]
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i
    status = params[:status] == nil ? 1 : params[:status].to_i

    if organization_id == nil
      seekers = Seeker.where(status: status).page(page).per(limit)
    else
      seekers = Seeker.where(status: status, organization_id: organization_id).page(page).per(limit)
    end
    for user in seekers do
      users.append(ApiHelper::seeker_to_json(user))
    end
    render json: users, status: 200
  end

  # GET /api/users/v1/admin/show?phone=123&user_id=1
  # Displays profile of user.
  #
  def show
    render(json: {code: 'users/not_found', message: 'User not found'}, status: 404) && return if @seeker.blank? and @broker.blank?
    if @seeker.present?
      render json: ApiHelper::seeker_to_json(@seeker), status: 200
    elsif @broker.present?
      render json: ApiHelper::broker_to_json(@broker), status: 200
    end
  end

  # DELETE /api/users/v1/admin/users/:id
  # Displays profile of user.
  #
  def destroy
    render(json: {code: 'users/not_found', message: 'User not found'}, status: 404) && return if @seeker == nil
    @seeker.ji_request = true
    @seeker.destroy!
    render json: {message: 'Seeker deleted.', id: params[:id]}
  end

  # POST /api/users/v1/admin/users/check_if_exists
  # return true if user exists, false otherwise
  #
  def check_if_exists
    phone = PhonyRails.normalize_number(login_params[:phone], default_country_code: 'CH') if params[:phone].present?
    # is_seeker_exists = Seeker.where("mobile = ? OR id = ? OR email = ?", phone, params[:seeker_id], params[:email] ).any?
    is_seeker_exists = nil
    if phone.present?
      is_seeker_exists = Seeker.where(mobile: phone)
    end
    if params[:seeker_id].present? and !is_seeker_exists.nil?
      is_seeker_exists = is_seeker_exists.where(id: params[:seeker_id])
    elsif params[:seeker_id].present?
      is_seeker_exists = Seeker.where(id: params[:seeker_id])
    end
    if params[:email].present? and !is_seeker_exists.nil?
      is_seeker_exists = is_seeker_exists.where(email: params[:email])
    elsif params[:email].present?
      is_seeker_exists = Seeker.where(email: params[:email])
    end

    # is_broker_exists = Broker.where("mobile = ? OR id = ? OR email = ?", phone, params[:broker_id], params[:email] ).any?
    is_broker_exists = nil
    if phone.present?
      is_broker_exists = Broker.where(mobile: phone)
    end
    if params[:broker_id].present? and is_broker_exists.nil?
      is_broker_exists = is_broker_exists.where(id: params[:broker_id])
    elsif params[:broker_id].present?
      is_broker_exists = Broker.where(id: params[:broker_id])
    end
    if params[:email].present? and is_broker_exists.nil?
      is_broker_exists = is_broker_exists.where(email: params[:email])
    elsif params[:email].present?
      is_broker_exists = Broker.where(email: params[:email])
    end


    render json: {exists: (is_seeker_exists.present? or is_broker_exists.present?)}
  end

  def create_seekers_access_token
    token = AccessToken.find_by(userable_id: @seeker.id, userable_type: 'Seeker', device_id: params[:device_id])
    if token.present? and token.expire_at < DateTime.now
      Rails.logger.info "LOGGER API admin old token: #{token.inspect}"
      token.destroy!
    end

    if token.blank? or token.expire_at < DateTime.now
      token = AccessToken.new(userable_id: @seeker.id, userable_type: 'Seeker',  token_type: 'bearer', device_id: params[:device_id])
      token.expire_at = DateTime.now() + ENV['TOKEN_EXPIRATION'].to_i.days
      token.save!
      Rails.logger.info "LOGGER API admin new token: #{token.inspect}"
    end

    render json: {
      access_token: token.access_token,
      token_type: token.token_type,
      expires_in: token.expire_at.strftime('%s'),
      created_at: token.created_at,
      refresh_token: token.refresh_token,
      user: ApiHelper::seeker_to_json(@seeker)
    }, status: 200
  end

  def update
    user_params = set_update_params
    if @seeker.update(user_params)
      render json: {message: 'User updated successfully'}, status: 200
    else
      render json: {code: 'users/invalid', message: @seeker.errors.first}, status: 422
    end
  end

  private
  def update_params
    params.permit(:phone, :password, :app_user_id, :organization_id, :firstname, :lastname, :birthdate, :place_id,
                  :street, :sex, :status, :categories, :login, :mobile, :email, :parent_email, :additional_contacts, :languages,
                  :occupation, :occupation_end_date, :contact_availability, :contact_preference, :rc_id, :rc_username)
  end
  def set_update_params
    user_params = update_params
    user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s') if user_params[:birthdate] != nil
    user_params[:occupation_end_date] = DateTime.strptime(user_params[:occupation_end_date], '%s') if user_params[:occupation_end_date] != nil
    user_params[:work_category_ids] = JSON.parse user_params[:categories] if user_params[:categories] != nil
    user_params[:password_confirmation] = user_params[:password] if user_params[:password] != nil
    user_params[:ji_request] = true
    user_params.except!(:birthdate, :categories)
    user_params
  end

  def set_user_via_phone
    phone = PhonyRails.normalize_number(params[:phone], default_country_code: 'CH')
    @seeker = Seeker.where("mobile = ? OR login = ? OR phone = ?", phone, login_params[:phone], phone ).first
    @seeker || render_phone_errors
  end

  def render_phone_errors
    render(json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404) && return if @seeker.nil?
  end

  def set_seeker
    @seeker = Seeker.find_by(id: params[:id])
  end

  # changes we search o
  def set_seeker_by_phone_or_id
    @seeker = nil
    @broker = nil
    if params[:phone].present?
      phone = PhonyRails.normalize_number(login_params[:phone], default_country_code: 'CH')
      if phone.present?
        @seeker = Seeker.where(mobile: phone)
        @broker = Broker.where(mobile: phone)
      end
    end
    if params[:seeker_id].present? and params[:broker_id].blank? and @seeker.nil?
      @seeker = Seeker.where(id: params[:seeker_id])
    elsif  params[:seeker_id].present? and params[:broker_id].blank?
      @seeker = @seeker.where(id: params[:seeker_id])
    end

    if params[:seeker_id].blank? and params[:broker_id].present? and @seeker.nil?
      @broker = Broker.where(id: params[:broker_id])
    elsif params[:seeker_id].blank? and params[:broker_id].present?
      @broker = @broker.where(id: params[:broker_id])
    end
    if params[:email].present? and @seeker.nil?
      @seeker = Seeker.where(email: params[:email])
    elsif params[:email].present?
      @seeker = @seeker.where(email: params[:email])
    end
    if params[:email].present? and @broker.nil?
      @broker = Broker.where(email: params[:email])
    elsif params[:email].present?
      @broker = @broker.where(email: params[:email])
    end

    if @seeker.present?
      return @seeker = @seeker.first
    else
      @seeker = nil
    end
    if @broker.present?
      return @broker = @broker.first
    else
      @broker = nil
    end
    nil
  end

  def login_params
    params.permit(:phone, :password)
  end

  def register_params
    params.permit(:parents_email, :parent_email, :email, :zip, :phone, :password, :app_user_id, :organization_id,
                  :firstname, :lastname, :birthdate, :place_id, :street, :sex, :categories)
  end
end
