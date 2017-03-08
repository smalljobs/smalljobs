class ApiController < ApplicationController
  before_action :authenticate, except: [:login, :register]
  before_action :check_status, only: [:create_assignment, :update_assignment, :apply]
  skip_before_filter :verify_authenticity_token

  def login
    seeker = Seeker.find_by(login: login_params[:phone]) || Seeker.find_by(phone: login_params[:phone])

    if seeker == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    if !seeker.valid_password?(login_params[:password])
      render json: {code: 'users/invalid', message: 'Invalid phone or password'}, status: 422
      return
    end

    token = AccessToken.find_by(seeker_id: seeker.id)
    if token != nil
      token.destroy!
    end

    token = AccessToken.new(seeker_id: seeker.id, token_type: 'bearer')
    token.expire_at = DateTime.now() + 30.days
    token.save!

    expires_in = token.created_at + 30.days
    expires_in -= token.created_at

    render json: {access_token: token.access_token, token_type: token.token_type, expires_in: expires_in, created_at: token.created_at, refresh_token: token.refresh_token, user: ApiHelper::seeker_to_json(seeker)}, status: 200
  end

  def logout
    authorization_header = request.authorization()
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      token = AccessToken.find_by(access_token: token)
      token.destroy!
    end

    render json: {message: 'Success. Access token is no longer active.'}, status: 200
  end

  def register
    user_params = register_params
    user_params[:date_of_birth] = DateTime.strptime(user_params[:birthdate], '%s')
    user_params.except!(:birthdate)
    user_params[:login] = user_params[:phone]
    user_params[:mobile] = user_params[:phone]
    if user_params[:categories] != nil
      user_params[:work_category_ids] = JSON.parse user_params[:categories]
      user_params.except!(:categories)
    end

    user_params[:password_confirmation] = user_params[:password]
    seeker = Seeker.new(user_params)
    seeker.status = 1
    if !seeker.save
      render json: {code: 'users/invalid', message: seeker.errors.first}, status: 422
      return
    end

    render json: {message: 'User created successfully', user: ApiHelper::seeker_to_json(seeker), organization: ApiHelper::organization_to_json(seeker.organization, seeker.organization.regions.first.id)}
  end

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

  def show_user
    user = Seeker.find_by(id: params[:id])
    if user == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    render json: ApiHelper::seeker_to_json(user), status: 200
  end

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
      render json: {'message': 'User updated successfully'}, status: 200
    else
      render json: {code: 'users/invalid', message: seeker.errors.first}, status: 422
    end
  end

  def list_regions
    regions = []
    Region.all.find_each do |region|
      regions.append(ApiHelper::region_to_json(region))
    end

    render json: regions, status: 200
  end

  def show_region
    region = Region.find_by(id: params[:id])
    if region == nil
      render json: {code: 'market/not_found', message: 'Region not found'}, status: 404
      return
    end

    render json: ApiHelper::region_to_json(region), status: 200
  end

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
      for organization in region.organizations
        if organization.active == active
          organizations.append(ApiHelper::organization_to_json(organization, region.id))
        end
      end
    else
      Organization.where(active: active).find_each do |organization|
        organizations.append(ApiHelper::organization_to_json(organization, organization.regions.first.id))
      end
    end


    render json: organizations, status: 200
  end

  def show_organization
    organization = Organization.find_by(id: params[:id])
    if organization == nil
      render json: {code: 'market/not_found', message: 'Organization not found'}, status: 404
      return
    end

    render json: ApiHelper::organization_to_json(organization, organization.regions.first.id), status: 200
  end

  def list_jobs
    organization_id = params[:organization_id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    state = Job::state_from_integer(status)

    jobs = []
    if organization_id == nil
      if state == nil
        found_jobs = Job.all.page(page).per(limit)
        for job in found_jobs do
          jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, nil))
        end
      else
        found_jobs = Job.where(state: state).page(page).per(limit)
        for job in found_jobs do
          jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, nil))
        end
      end
    else
      if state == nil
        found_jobs = Job.joins(:provider).where(providers: {organization_id: organization_id}).page(page).per(limit)
        for job in found_jobs do

          jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, nil))
        end
      else
        found_jobs = Job.joins(:provider).where(state: state, providers: {organization_id: organization_id}).page(page).per(limit)
        for job in found_jobs do
          jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, nil))
        end
      end
    end

    render json: jobs, status: 200
  end

  def apply
    id = params[:id]
    message = params[:message]
    job = Job.find_by(id: id)
    if job == nil
      render json: {code: 'jobs/not_found', message: 'Job not found'}, status: 404
      return
    end

    allocation = Allocation.find_by(job_id: id, seeker_id: @seeker.id)
    if allocation != nil
      render json: {code: 'jobs/applied', message: 'Already applied for that job'}, status: 422
      return
    end

    allocation = Allocation.new(job_id: id, seeker_id: @seeker.id, state: :application_open, feedback_seeker: message)
    allocation.save!

    render json: {message: 'Success. Please wait for a message from broker.'}, status: 201
  end

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

    if allocation.cancelled?
      render json: {code: 'jobs/cancelled', message: 'Application already cancelled'}, status: 422
      return
    end

    allocation.state = :cancelled
    allocation.save!
    render json: {message: 'Success.'}, status: 200
  end

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

    render json: ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, nil), status: 200
  end

  def list_my_jobs
    id = params[:id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    state = nil
    if status == 0
      state = 'available'
    elsif status == 1
      state = 'connected'
    elsif status == 2
      state = 'rated'
    end

    jobs = []
    if state == nil
      found_jobs = Job.joins(:allocations).where(allocations: {seeker_id: id}).page(page).per(limit)
      for job in found_jobs do
        allocation = job.allocations.where(seeker_id: id).first
        allocation_id = allocation != nil ? allocation.id : nil
        jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, allocation_id))
      end
    else
      found_jobs = Job.joins(:allocations).where(allocations: {seeker_id: id}, state: state).page(page).per(limit)
      for job in found_jobs do
        allocation = job.allocations.where(seeker_id: id).first
        allocation_id = allocation != nil ? allocation.id : nil
        jobs.append(ApiHelper::job_to_json(job, job.provider.organization, show_provider, show_organization, show_assignments, allocation_id))
      end
    end

    render json: jobs, status: 200
  end

  def create_assignment
    start_datetime = params[:start_timestamp]
    if start_datetime != nil
      start_datetime = DateTime.strptime(start_datetime, '%s')
    end

    assignment = Assignment.new(status: :active, job_id: params[:job_id], seeker_id: params[:user_id], provider_id: params[:provider_id], feedback: params[:message], start_time: start_datetime)
    if !assignment.save
      render json: {code: 'assignments/invalid', message: assignment.errors.first}, status: 422
      return
    end

    render json: ApiHelper::assignment_to_json(assignment), status: 201
  end

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

  def list_assignments
    organization_id = params[:organization_id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_seeker = true?(params[:user])
    show_job = true?(params[:job])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    state = nil
    if status == 0
      state = 0
    elsif status == 1
      state = 1
    end

    assignments = []
    if organization_id == nil
      if state == nil
        found_assignments = Assignment.all.page(page).per(limit)
        for assignment in found_assignments do
          assignments.append(ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job))
        end
      else
        found_assignments = Assignment.where(status: state).page(page).per(limit)
        for assignment in found_assignments do
          assignments.append(ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job))
        end
      end
    else
      if state == nil
        found_assignments = Assignment.joins(:provider).where(providers: {organization_id: organization_id}).page(page).per(limit)
        for assignment in found_assignments do
          assignments.append(ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job))
        end
      else
        found_assignments = Assignment.joins(:provider).where(providers: {organization_id: organization_id}, status: state).page(page).per(limit)
        for assignment in found_assignments do
          assignments.append(ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job))
        end
      end
    end

    render json: assignments, status: 200
  end

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

  protected
  def true?(obj)
    obj.to_s == 'true'
  end

  def check_status
    @seeker.active? || render_unauthorized_status
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

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

    expiration_date = token.expire_at || (token.created_at + 30.days)
    if expiration_date < DateTime.now
      return false
    end

    @seeker = Seeker.find_by(id: token.seeker_id)
    return true
  end

  def render_unauthorized
    render json: {code: 'users/invalid', message: 'Invalid access token'}, status: 422
  end

  def render_unauthorized_status
    render json: {code: 'users/status', message: 'Invalid user status'}, status: 422
  end

  def login_params
    params.permit(:phone, :password)
  end

  def register_params
    params.permit(:phone, :password, :app_user_id, :organization_id, :firstname, :lastname, :birthdate, :place_id, :street, :sex, :categories)
  end

  def update_params
    params.permit(:phone, :password, :app_user_id, :organization_id, :firstname, :lastname, :birthdate, :place_id, :street, :sex, :status, :categories)
  end
end
