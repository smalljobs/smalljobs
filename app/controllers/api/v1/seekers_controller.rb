class Api::V1::SeekersController < Api::V1::ApiController
  before_action :authenticate_via_phone, only: [:password_validate, :password_change, :password_remind]
  skip_before_action :authenticate, only: [:password_validate, :password_change, :password_remind]

  # POST /api/v1/users/login
  # Performs the login.
  # Returns a access_token which is passed along as a header with all future requests to authenticate the user.
  # You must provide the Authorization: Bearer {access_token} header in all other requests.
  # Access tokens are tied to the user who logs in. Tokens are only valid for 30 days.
  #
  def login
    phone = PhonyRails.normalize_number(login_params[:phone], default_country_code: 'CH')
    seeker = Seeker.find_by(mobile: phone) || Seeker.find_by(login: login_params[:phone]) || Seeker.find_by(phone: phone)

    if seeker == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    if !seeker.valid_password?(login_params[:password])
      render json: {code: 'users/invalid', message: 'Invalid phone or password'}, status: 422
      return
    end

    token = AccessToken.find_by(userable_id: seeker.id, userable_type: 'Seeker')
    if token.present? and token.expire_at < DateTime.now
      Rails.logger.info "LOGGER API seeker old token: #{token.inspect}"
      token.destroy!
    end
    if token.blank? or token.expire_at < DateTime.now
      token = AccessToken.new(userable_id: seeker.id, userable_type: 'Seeker', token_type: 'bearer')
      token.expire_at = DateTime.now() + 360.days
      token.save!
      Rails.logger.info "LOGGER API seeker new token: #{token.inspect}"
    end
    # expires_in = token.created_at + 30.days
    # expires_in -= token.created_at

    render json: {access_token: token.access_token, token_type: token.token_type, expires_in: token.expire_at.strftime('%s'), created_at: token.created_at, refresh_token: token.refresh_token, user: ApiHelper::seeker_to_json(seeker)}, status: 200
  end

  # GET /api/v1/users/logout
  # Invalidates access_token
  #
  def logout
    authorization_header = request.authorization()
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      token = AccessToken.find_by(access_token: token)
      token.destroy!
    end

    render json: {message: 'Success. Access token is no longer active.'}, status: 200
  end

  # POST /api/v1/users/register
  # Register new user.
  # By default, new users have status: status = 1.
  #
  def register
    user_params = register_params
    if user_params[:birthdate] == nil
      render json: {code: 'users/invalid', message: 'Birthdate not present'}, status: 422
      return
    end

    user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s').in_time_zone('Warsaw')
    user_params.except!(:birthdate)
    # user_params[:login] = user_params[:phone]
    if user_params[:mobile].blank?
      user_params[:mobile] = user_params[:phone]
    end
    if user_params[:categories] != nil
      user_params[:work_category_ids] = JSON.parse user_params[:categories]
      user_params.except!(:categories)
    end

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
    Current.user = seeker
    seeker.is_register = true
    if !seeker.save
      render json: {code: 'users/invalid', message: seeker.errors.first}, status: 422
      return
    end
    Current.user = nil

    if seeker.place.nil?
      seeker.place = seeker.organization.place
      seeker.save
    end

    #title = 'Willkommen'
    host = "#{seeker.organization.regions.first.subdomain}.smalljobs.ch"
    #seeker_agreement_link = url_for(agreement_broker_seeker_url(seeker.agreement_id, subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https'))
    #registration_welcome_message = Mustache.render(seeker.organization.welcome_app_register_msg || '', seeker_first_name: seeker.firstname, seeker_last_name: seeker.lastname, seeker_link_to_agreement: "<a file type='application/pdf' title='Elterneinverständnis herunterladen' href='#{seeker_agreement_link}'>#{seeker_agreement_link}</a>", broker_first_name: seeker.organization.brokers.first.firstname, broker_last_name: seeker.organization.brokers.first.lastname, organization_name: seeker.organization.name, organization_street: seeker.organization.street, organization_zip: seeker.organization.place.zip, organization_place: seeker.organization.place.name, organization_phone: seeker.organization.phone, organization_email: seeker.organization.email, link_to_jobboard_list: url_for(root_url(subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')))
    #registration_welcome_message.gsub! "\r\n", "<br>"
    #registration_welcome_message.gsub! "\n", "<br>"
    # MessagingHelper::send_message(title, message, seeker.app_user_id, seeker.organization.email)

    unless seeker.parent_email.nil?
      parent_message = Mustache.render(seeker.organization.welcome_email_for_parents_msg || '', seeker_first_name: seeker.firstname, seeker_last_name: seeker.lastname, seeker_link_to_agreement: url_for(agreement_broker_seeker_url(seeker.agreement_id, subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')), broker_first_name: seeker.organization.brokers.first.firstname, broker_last_name: seeker.organization.brokers.first.lastname, organization_name: seeker.organization.name, organization_street: seeker.organization.street, organization_zip: seeker.organization.place.zip, organization_place: seeker.organization.place.name, organization_phone: seeker.organization.phone, organization_email: seeker.organization.email, link_to_jobboard_list: url_for(root_url(subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')))
      parent_message.gsub! "\n", "<br>"
      Notifier.send_welcome_message_for_parents(parent_message, seeker.parent_email).deliver
    end

    #render json: {message: 'User created successfully', user: ApiHelper::seeker_to_json(seeker), organization: ApiHelper::organization_to_json(seeker.organization, seeker.organization.regions.first.id, registration_welcome_message, seeker_agreement_link)}
    render json: {message: 'User created successfully', user: ApiHelper::seeker_to_json(seeker)}
  end

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

  # PATCH /api/v1/user
  # Destroy profile of a user.
  def destroy
    if @seeker.destroy
      render json: {message: 'User deleted'}, status: 200
    else
      render json: {code: 'users/invalid', message: @seeker.errors.first}, status: 422
    end
  end

  # POST /api/v1/users/password/validate
  # Check if passed security code is valid
  #
  def password_validate
    render(json: {message: 'Success. Security code is valid.'}, status: 200)
  end

  # POST /api/v1/users/password/change
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

  # POST /api/v1/users/password/remind
  # Check if user with passed phone number exists in database
  # If user exists then send 6 digit code via SMS
  #
  def password_remind
    if @seeker.last_recovery == DateTime.now.to_date && @seeker.recovery_times.to_i >= 3
      render json: {code: 'users/limit_exceeded', message: 'Exceeded daily recovery limit'}
      return
    end

    if @seeker.last_recovery == DateTime.now.to_date
      @seeker.recovery_times += 1
    else
      @seeker.last_recovery = DateTime.now.to_date
      @seeker.recovery_times = 1
    end

    code = ApiHelper::generate_code
    client = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'], secret: ENV['NEXMO_API_SECRET'])
    response = client.send_message(from: 'Jugendapp', to: params[:phone], text: "#{code} ist dein Code. Bitte in der App eingeben.")
    logger.info "Response from nexmo: #{response}"

    if response['messages'][0]['status'] == '0'
      @seeker.recovery_code = code
      @seeker.save!
      render json: {message: 'Success. SMS sent to user'}, status: 200
    else
      render json: {code: 'users/error', message: 'Error sending message'}, status: 500
    end
  end

  # PUT /api/messages/update
  # Called when new message was sent by seeker
  #
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
                  :street, :sex, :status, :categories, :login, :mobile, :email, :parent_email, :additional_contacts, :languages,
                  :occupation, :occupation_end_date, :contact_availability, :contact_preference, :rc_id, :rc_username)
  end

  def login_params
    params.permit(:phone, :password)
  end

  def register_params
    params.permit(:parents_email, :parent_email, :email, :zip, :phone, :password, :app_user_id, :organization_id, :firstname, :lastname,
                  :birthdate, :place_id, :street, :sex, :categories, :rc_id, :rc_username, :mobile)
  end

end
