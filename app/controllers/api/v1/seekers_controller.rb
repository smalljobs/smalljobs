class Api::V1::SeekersController < Api::V1::ApiController
  before_action :authenticate_via_phone, only: [:password_validate, :password_change]
  skip_before_action :authenticate, only: [:password_validate, :password_change]

  # GET /api/v1/user
  # Displays profile of user.
  #
  def show
    render json: ApiHelper::seeker_to_json(@seeker), status: 200
  end

  # PATCH /api/v1/user
  # Updates profile of user.
  def update
    user_params = set_update_params
    if @seeker.update(user_params)
      render json: {message: 'User updated successfully'}, status: 200
    else
      render json: {code: 'users/invalid', message: @seeker.errors.first}, status: 422
    end
  end

  # POST /api/v1/user/password/validate
  # Check if passed security code is valid
  #
  def password_validate
    render(json: {message: 'Success. Security code is valid.'}, status: 200)
  end

  # POST /api/v1/user/password/change
  # Change user password
  # Cancel action when phone number or security code are invalid
  #
  def password_change
    if @seeker.update(password: params[:password], recovery_code: nil)
      render json: {message: 'Success. Password changed successfully.'}, status: 200
    else
      render json: {code: 'users/error', message: seeker.errors.first}, status: 422
    end
  end

  def update_messages
    api_key = params[:token]
    seeker_id = params[:user_id]

    logger.info "Called update message. Send #{params}, #{params[:token]}, #{params[:user_id]}"

    if api_key != 'eizSpz2JIsKE30Wn8qvd9Bl19LWhPxZM'
      render json: {code: 'messages/error', message: 'Invalid API key'}, status: 401
      logger.info "Invalid api key"
      return
    end

    seeker = Seeker.find_by(id: seeker_id)
    if seeker.nil?
      render json: {code: 'messages/error', message: 'Seeker not found'}, status: 404
      logger.info "Invalid seeker"
      return
    end

    seeker.save
    logger.info "Success"
    render json: {message: 'Success'}, status: 200
  end

  private

  def authenticate_via_phone
    phone = PhonyRails.normalize_number(params[:phone], default_country_code: 'CH')
    @seeker = Seeker.find_by(mobile: phone)
    @seeker || render_phone_errors
  end

  def render_phone_errors
    render(json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404) && return if @seeker.nil?
    render(json: {code: 'users/invalid', message: 'Invalid code'}, status: 401) && return if @seeker.recovery_code != params[:code]
  end

  def set_update_params
    user_params = update_params
    user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s') if user_params[:birthdate] != nil
    user_params[:occupation_end_date] = DateTime.strptime(user_params[:occupation_end_date], '%s') if user_params[:occupation_end_date] != nil
    user_params[:work_category_ids] = JSON.parse user_params[:categories] if user_params[:categories] != nil
    user_params[:password_confirmation] = user_params[:password] if user_params[:password] != nil
    user_params.except!(:birthdate, :categories)
    user_params
  end

  def update_params
    params.permit(:phone, :password, :app_user_id, :organization_id, :firstname, :lastname, :birthdate, :place_id,
                  :street, :sex, :status, :categories, :login, :mobile, :email, :additional_contacts, :languages,
                  :occupation, :occupation_end_date, :contact_availability, :contact_preference)
  end
end