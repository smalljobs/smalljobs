class ApiController < ApplicationController
  before_action :authenticate, except: [:login, :register, :password_remind, :password_validate, :password_change, :update_messages]
  before_action :check_status, only: [:create_assignment, :update_assignment, :apply]
  skip_before_filter :verify_authenticity_token

  # POST /api/users/login
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
      Rails.logger.info "LOGGER API old token: #{token.inspect}"
      token.destroy!
    end
    if token.blank? or token.expire_at < DateTime.now
      token = AccessToken.new(userable_id: seeker.id, userable_type: 'Seeker', token_type: 'bearer')
      token.expire_at = DateTime.now() + ENV['TOKEN_EXPIRATION'].to_i.days
      token.save!
      Rails.logger.info "LOGGER API new token: #{token.inspect}"
    end
    # expires_in = token.created_at + 30.days
    # expires_in -= token.created_at

    render json: {access_token: token.access_token, token_type: token.token_type, expires_in: token.expire_at.strftime('%s'), created_at: token.created_at, refresh_token: token.refresh_token, user: ApiHelper::seeker_to_json(seeker)}, status: 200
  end

  # GET /api/users/logout
  # Invalidates access_token
  #
  def logout
    authorization_header = request.authorization()
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      token = AccessToken.find_by(access_token: token)
      Rails.logger.info "LOGGER API logout: #{token.inspect}"
      token.destroy!
    end

    render json: {message: 'Success. Access token is no longer active.'}, status: 200
  end

  # POST /api/users/register
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
    user_params[:login] = user_params[:phone]
    user_params[:mobile] = user_params[:phone]
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


    parents_email = user_params[:parents_email]
    user_params.except!(:parents_email)
    user_params[:email] = parents_email

    seeker = Seeker.new(user_params)
    seeker.status = 'inactive'
    seeker.is_register = true
    seeker.ji_request = true
    if !seeker.save
      render json: {code: 'users/invalid', message: seeker.errors.first}, status: 422
      return
    end

    if seeker.place.nil?
      seeker.place = seeker.organization.place
      seeker.save
    end

    title = 'Willkommen'
    host = "#{seeker.organization.regions.first.subdomain}.smalljobs.ch"

    seeker_agreement_link = url_for(agreement_broker_seeker_url(seeker.agreement_id, subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https'))
    registration_welcome_message = Mustache.render(seeker.organization.welcome_app_register_msg || '', seeker_first_name: seeker.firstname, seeker_last_name: seeker.lastname, seeker_link_to_agreement: "<a file type='application/pdf' title='Elterneinverständnis herunterladen' href='#{seeker_agreement_link}'>#{seeker_agreement_link}</a>", broker_first_name: seeker.organization.brokers.first.firstname, broker_last_name: seeker.organization.brokers.first.lastname, organization_name: seeker.organization.name, organization_street: seeker.organization.street, organization_zip: seeker.organization.place.zip, organization_place: seeker.organization.place.name, organization_phone: seeker.organization.phone, organization_email: seeker.organization.email, link_to_jobboard_list: url_for(root_url(subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')))

    registration_welcome_message.gsub! "\r\n", "<br>"
    registration_welcome_message.gsub! "\n", "<br>"

    unless parents_email.blank?
      parent_message = Mustache.render(seeker.organization.welcome_email_for_parents_msg || '', seeker_first_name: seeker.firstname, seeker_last_name: seeker.lastname, seeker_link_to_agreement: url_for(agreement_broker_seeker_url(seeker.agreement_id, subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')), broker_first_name: seeker.organization.brokers.first.firstname, broker_last_name: seeker.organization.brokers.first.lastname, organization_name: seeker.organization.name, organization_street: seeker.organization.street, organization_zip: seeker.organization.place.zip, organization_place: seeker.organization.place.name, organization_phone: seeker.organization.phone, organization_email: seeker.organization.email, link_to_jobboard_list: url_for(root_url(subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')))
      parent_message.gsub! "\n", "<br>"
      Notifier.send_welcome_message_for_parents(parent_message, parents_email).deliver
    end

    render json: {message: 'User created successfully', user: ApiHelper::seeker_to_json(seeker), organization: ApiHelper::organization_to_json(seeker.organization, seeker.organization.regions.first.id, registration_welcome_message)}
  end

  # GET /api/users
  # Returns list of users.
  # Optionally you can retrieve list of users from defined organization.
  #
  def list_users
    users = []
    organization_id = params[:organization_id]
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i
    status = params[:status] == nil ? 1 : params[:status].to_i

    if organization_id == nil
      seekers = Seeker.where(status: status).page(page).per(limit)
      for user in seekers do
        users.append(ApiHelper::seeker_to_json(user))
      end
    else
      seekers = Seeker.where(status: status, organization_id: organization_id).page(page).per(limit)
      for user in seekers do
        users.append(ApiHelper::seeker_to_json(user))
      end
    end

    render json: users, status: 200
  end

  # GET /api/users/[id]
  # Displays profile of user.
  #
  def show_user
    user = Seeker.find_by(id: params[:id])
    if user == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    render json: ApiHelper::seeker_to_json(user), status: 200
  end

  # PATCH /api/users/[id]
  # Updates user data
  #
  def update_user
    seeker = Seeker.find_by(id: params[:id])
    if seeker == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    if seeker.id != @seeker.id
      render json: {code: 'users/not_allowed', message: 'Cannot change another user data'}, status: 401
      return
    end

    user_params = update_params
    if user_params[:birthdate] != nil
      user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s')
      user_params.except!(:birthdate)
    end

    if user_params[:categories] != nil
      user_params[:work_category_ids] = JSON.parse user_params[:categories]
      user_params.except!(:categories)
    end

    if user_params[:password] != nil
      user_params[:password_confirmation] = user_params[:password]
    end

    if seeker.update(user_params)
      render json: {message: 'User updated successfully'}, status: 200
    else
      render json: {code: 'users/invalid', message: seeker.errors.first}, status: 422
    end
  end

  # GET /api/market/regions
  # Returns all available regions
  #
  def list_regions
    regions = []
    Region.all.find_each do |region|
      regions.append(ApiHelper::region_to_json(region))
    end

    render json: regions, status: 200
  end

  # GET /api/market/regions/[region]
  # Returns single region
  #
  def show_region
    region = Region.find_by(id: params[:id])
    if region == nil
      render json: {code: 'market/not_found', message: 'Region not found'}, status: 404
      return
    end

    render json: ApiHelper::region_to_json(region), status: 200
  end

  # GET /api/market/organizations?region=1&active=true
  # Returns all available organizations
  # Optionally display organizations from specific region
  #
  def list_organizations
    region = nil
    if params[:region] != nil
      region = Region.find_by(id: params[:region])
      if region == nil
        render json: {code: 'market/not_found', message: 'Region not found'}, status: 404
        return
      end
    end

    active = params[:active]
    if active == nil || active == 'true' || active == true
      active = true
    else
      active = false
    end

    organizations = []
    if region != nil
      for organization in region.organizations.where(active: true).distinct
        if organization.active == active
          organizations.append(ApiHelper::organization_to_json(organization, region.id))
        end
      end
    else
      Organization.where(active: active).find_each do |organization|
        organizations.append(ApiHelper::organization_to_json(organization, organization.regions.first.try(:id)))
      end
    end


    render json: organizations, status: 200
  end

  # GET /api/market/organizations/[id]
  # Returns organization details
  #
  def show_organization
    organization = Organization.find_by(id: params[:id])
    if organization == nil
      render json: {code: 'market/not_found', message: 'Organization not found'}, status: 404
      return
    end

    render json: ApiHelper::organization_to_json(organization, organization.regions.first.id), status: 200
  end

  # Get /api/jobs?organization_id=1&region_id=1&status=1&provider=true&organization=true&assignments=true&page=1&limit=10
  # Returns list of available jobs
  # Optionally you can retrieve list of jobs from defined organization
  #
  def list_jobs
    organization_id = params[:organization_id]
    region_id = params[:region_id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    state = Job::state_from_integer(status)

    jobs = []
    found_jobs = []

    if !region_id.nil?
      region = Region.find_by(id: region_id)
      if region.nil?
        render json: {code: 'jobs/not_found', message: 'Region not found'}, status: 404
        return
      end

      found_jobs = region.jobs
      if !organization_id.nil?
        found_jobs = found_jobs.where(organization_id: organization_id)
      end
    else
      if !organization_id.nil?
        found_jobs = Job.joins(:provider).where(providers: {organization_id: organization_id})
      else
        found_jobs = Job.all
      end
    end

    if !state.nil?
      found_jobs = found_jobs.where(state: state)
    end

    found_jobs = found_jobs.page(page).per(limit)

    for job in found_jobs do
      jobs.append(ApiHelper::job_to_json(job, job.organization, show_provider, show_organization, show_assignments, nil, @seeker))
    end

    render json: jobs, status: 200
  end

  # POST /api/jobs/apply
  # Applies for a job
  #
  def apply
    id = params[:id]
    message = params[:message]
    job = Job.find_by(id: id)
    if job == nil
      render json: {code: 'jobs/not_found', message: 'Job not found'}, status: 404
      return
    end

    allocation = Allocation.find_by(job_id: id, seeker_id: @seeker.id)
    status_ok = true
    if job.state != 'public' && job.state != 'check'
      status_ok = false
    end

    if allocation != nil
      if allocation.application_retracted?
        if !status_ok
          render json: {code: 'jobs/incorrect_status', message: 'Der Job wurde leider in der Zwischenzeit deaktiviert oder vergeben.'}, status: 406
          return
        end
        allocation.state = :application_open
        allocation.save!
        render json: {message: 'Success. Please wait for a message from broker.'}, status: 201
      else
        render json: {code: 'jobs/applied', message: 'Already applied for that job'}, status: 422
      end

      return
    end

    if !status_ok
      render json: {code: 'jobs/incorrect_status', message: 'Der Job wurde leider in der Zwischenzeit deaktiviert oder vergeben.'}, status: 406
      return
    end

    allocation = Allocation.new(provider_id: job.provider_id, job_id: id, seeker_id: @seeker.id, state: :application_open, feedback_seeker: message)
    allocation.save!

    render json: {message: 'Success. Please wait for a message from broker.'}, status: 201
  end

  # POST /api/jobs/revoke
  # Cancels previous user submission
  #
  def revoke
    id = params[:id]
    job = Job.find_by(id: id)
    if job == nil
      render json: {code: 'jobs/not_found', message: 'Job not found'}, status: 404
      return
    end

    allocation = Allocation.find_by(job_id: id, seeker_id: @seeker.id)
    if allocation == nil
      render json: {code: 'jobs/not_found', message: 'Application not found'}, status: 404
      return
    end

    if allocation.application_retracted?
      render json: {code: 'jobs/cancelled', message: 'Application already cancelled'}, status: 422
      return
    end

    allocation.state = :application_retracted
    allocation.save!
    render json: {message: 'Success.'}, status: 200
  end

  # GET /api/jobs/[id]?provider=true&organization=true&assignments=true
  # Display job details
  # Optionally show/hide provider or organization info
  #
  def show_job
    id = params[:id]
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    job = Job.find_by(id: id)
    if job == nil
      render json: {code: 'jobs/not_found', message: 'Job not found'}, status: 404
      return
    end

    status = 0
    if job.state == 'available'
      status = 0
    elsif job.state == 'connected'
      status = 1
    elsif job.state == 'rated'
      status = 2
    end

    render json: ApiHelper::job_to_json(job, job.organization, show_provider, show_organization, show_assignments, nil, @seeker), status: 200
  end

  # GET /api/allocations?user_id=1&job_id=1&user=true&provider=true&organization=true&assignments=true&status=0&page=1&limit=10
  # Display allocations list
  # Optionally show/hide provider or organization info
  #
  def list_my_jobs
    id = params[:user_id]
    status = params[:status] == nil ? nil : JSON.parse(params[:status])
    job_id = params[:job_id] == nil ? nil : params[:job_id]
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    show_seeker = true?(params[:user])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    allocations = []
    found_allocations = Allocation.where(seeker_id: id).all
    if status != nil
      found_allocations = found_allocations.where(state: status)
    end

    if job_id != nil
      found_allocations = found_allocations.where(job_id: job_id)
    end

    found_allocations = found_allocations.page(page).per(limit)

    for allocation in found_allocations
      allocations.append(ApiHelper::allocation_with_job_to_json(allocation, allocation.job, show_provider, show_organization, show_seeker, show_assignments, @seeker))
    end

    render json: allocations, status: 200
  end

  # POST /api/assignments
  # Create new assignment
  #
  def create_assignment
    start_datetime = params[:start_timestamp]
    if start_datetime != nil
      start_datetime = DateTime.strptime(start_datetime, '%s')
    end

    stop_datetime = params[:stop_timestamp]
    if stop_datetime != nil
      stop_datetime = DateTime.strptime(stop_datetime, '%s')
    end

    duration = params[:duration]
    if duration != nil
      duration = duration.to_i
    end

    status = :active
    if params[:status] != nil
      status = params[:status].to_i
      if status == 0
        status = :active
      else
        status = :finished
      end
    end

    assignment = Assignment.new(status: status, job_id: params[:job_id], seeker_id: params[:user_id], provider_id: params[:provider_id], feedback: params[:message], payment: params[:payment], start_time: start_datetime, end_time: stop_datetime, duration: duration)
    if !assignment.save
      render json: {code: 'assignments/invalid', message: assignment.errors.first}, status: 422
      return
    end

    render json: ApiHelper::assignment_to_json(assignment), status: 201
  end

  # PATCH /api/assignments/[id]
  # Update assignment data
  #
  def update_assignment
    assignment = Assignment.find_by(id: params[:id])
    if assignment == nil
      render json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404
      return
    end

    data = {}
    if params[:status] != nil
      data[:status] = params[:status].to_i
      if data[:status] == 0
        data[:status] = :active
      else
        data[:status] = :finished
      end
    end

    if params[:message] != nil
      data[:feedback] = params[:message]
    end

    if params[:start_timestamp] != nil
      data[:start_time] = DateTime.strptime(params[:start_timestamp], '%s')
    end

    if params[:stop_timestamp] != nil
      data[:end_time] = DateTime.strptime(params[:stop_timestamp], '%s')
    end

    if params[:duration] != nil
      data[:duration] = params[:duration].to_i
    end

    if params[:payment] != nil
      data[:payment] = params[:payment].to_f
    end

    if assignment.update(data)
      render json: ApiHelper::assignment_to_json(assignment), status: 200
    else
      render json: {code: 'assignments/invalid', message: assignment.errors.first}, status: 422
    end
  end

  # DELETE /api/assignments/[id]
  # Delete assignment
  # User can destroy only own assignments
  #
  def delete_assignment
    assignment = Assignment.find_by(id: params[:id])
    if assignment == nil
      render json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404
      return
    end

    if assignment.seeker_id != @seeker.id
      render json: {code: 'assignments/invalid', message: 'Assignment not owned'}, status: 422
      return
    end

    assignment.destroy!
    render json: {message: 'Assignment deleted.', id: params[:id]}
  end

  # GET /api/assignments?organization_id=1&user_id=1&provider_id=1&status=1&user=true&provider=true&organization=true&job=true&page=1&limit=10
  # Returns list of assignments
  # Optionally you can retrieve list of assignments from defined organization
  #
  def list_assignments
    organization_id = params[:organization_id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_seeker = true?(params[:user])
    show_job = true?(params[:job])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i
    seeker_id = params[:user_id]
    provider_id = params[:provider_id]

    state = nil
    if status == 0
      state = 0
    elsif status == 1
      state = 1
    end

    assignments = []
    found_assignments = []

    if organization_id == nil
      found_assignments = Assignment.all
    else
      found_assignments = Assignment.joins(:provider).where(providers: {organization_id: organization_id})
    end

    if state != nil
      found_assignments = found_assignments.where(status: state)
    end

    if seeker_id != nil
      found_assignments = found_assignments.where(seeker_id: seeker_id)
    end

    if provider_id != nil
      found_assignments = found_assignments.where(provider_id: provider_id)
    end

    found_assignments = found_assignments.page(page).per(limit)

    for assignment in found_assignments do
      assignments.append(ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job))
    end

    render json: assignments, status: 200
  end

  # GET /api/assignments/[id]?user=true&provider=true&organization=true&job=true
  # Display assignment details
  # Optionally show/hide user, emploter or organization info
  #
  def show_assignment
    id = params[:id]
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_seeker = true?(params[:user])
    show_job = true?(params[:job])
    assignment = Assignment.find_by(id: id)
    if assignment == nil
      render json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404
      return
    end

    render json: ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job)
  end

  # POST /api/users/password/remind
  # Check if user with passed phone number exists in database
  # If user exists then send 6 digit code via SMS
  #
  def password_remind
    phone = PhonyRails.normalize_number(params[:phone], default_country_code: 'CH')

    seeker = Seeker.find_by(mobile: phone)
    if seeker.nil?
      render json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404
      return
    end

    if seeker.last_recovery == DateTime.now.to_date && seeker.recovery_times.to_i >= 3
      render json: {code: 'users/limit_exceeded', message: 'Exceeded daily recovery limit'}
      return
    end

    if seeker.last_recovery == DateTime.now.to_date
      seeker.recovery_times += 1
    else
      seeker.last_recovery = DateTime.now.to_date
      seeker.recovery_times = 1
    end

    code = ApiHelper::generate_code

    client = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'], secret: ENV['NEXMO_API_SECRET'])

    response = client.send_message(from: 'Jugendapp', to: phone, text: "#{code} ist dein Code. Bitte in der App eingeben.")

    logger.info "Response from nexmo: #{response}"

    if response['messages'][0]['status'] == '0'
      seeker.recovery_code = code
      seeker.save!
      render json: {message: 'Success. SMS sent to user'}, status: 200
    else
      render json: {code: 'users/error', message: 'Error sending message'}, status: 500
    end
  end

  # POST /api/users/password/validate
  # Check if passed security code is valid
  #
  def password_validate
    phone = PhonyRails.normalize_number(params[:phone], default_country_code: 'CH')
    code = params[:code]

    seeker = Seeker.find_by(mobile: phone)
    if seeker.nil?
      render json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404
      return
    end

    if seeker.recovery_code != code
      render json: {code: 'users/invalid', message: 'Invalid code'}, status: 401
      return
    end

    render json: {message: 'Success. Security code is valid.'}, status: 200
  end

  # POST /api/users/password/change
  # Change user password
  # Cancel action when phone number or security code are invalid
  #
  def password_change
    phone = PhonyRails.normalize_number(params[:phone], default_country_code: 'CH')
    code = params[:code]
    password = params[:password]

    seeker = Seeker.find_by(mobile: phone)
    if seeker.nil?
      render json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404
      return
    end

    if seeker.recovery_code != code
      render json: {code: 'users/invalid', message: 'Invalid code'}, status: 401
      return
    end

    seeker.recovery_code = nil
    seeker.password = password

    if seeker.save
      render json: {message: 'Success. Password changed successfully.'}, status: 200
    else
      render json: {code: 'users/error', message: seeker.errors.first}, status: 422
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

  protected

  # Check if the value is true
  #
  # @param obj [Object] value to check
  #
  # @return [Bool] true if object is true, false otherwise
  #
  def true?(obj)
    obj.to_s == 'true'
  end

  # Check if seeker is active
  #
  def check_status
    @seeker.status == 'active' || render_unauthorized_status
  end

  # Check if authentication token is valid
  #
  def authenticate
    authenticate_token || render_unauthorized
  end

  # Check if authentication token is valid
  #
  def authenticate_token
    token = nil
    authorization_header = request.authorization()
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      token = AccessToken.find_by(access_token: token)
    end

    if token == nil
      return false
    end

    expiration_date = token.expire_at || (token.created_at + ENV['TOKEN_EXPIRATION'].to_i.days)
    if expiration_date < DateTime.now
      return false
    end

    @seeker = Seeker.find_by(id: token.userable_id)
    return true
  end

  # Return information about invalid access token
  #
  def render_unauthorized
    render json: {code: 'users/invalid', message: 'Invalid access token'}, status: 422
  end

  # Return information about invalid user status
  #
  def render_unauthorized_status
    render json: {code: 'users/status', message: 'Invalid user status'}, status: 422
  end

  def login_params
    params.permit(:phone, :password)
  end

  def register_params
    params.permit(:parents_email, :zip, :phone, :password, :app_user_id, :organization_id, :firstname, :lastname,
                  :birthdate, :place_id, :street, :sex, :categories, :rc_id, :rc_username)
  end

  def update_params
    params.permit(:phone, :password, :app_user_id, :organization_id, :firstname, :lastname, :birthdate, :place_id,
                  :street, :sex, :status, :categories, :rc_id, :rc_username)
  end
end
