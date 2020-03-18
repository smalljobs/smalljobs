class Api::V1::JobsController < Api::V1::ApiController
  # Get /api/jobs?organization_id=1&region_id=1&status=1&provider=true&organization=true&assignments=true&page=1&limit=10
  # Returns list of available jobs
  # Optionally you can retrieve list of jobs from defined organization
  #
  def index
    organization_id = params[:organization_id]
    region_id = params[:region_id]
    status = params[:status] == nil ? nil : params[:status].to_i
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 10 : params[:limit].to_i

    show_allocations = true?(params[:allocations])

    state = Job::state_from_integer(status)

    jobs = []
    found_jobs = []

    if region_id.present?
      region = Region.find_by(id: region_id)
      render(json: {code: 'jobs/not_found', message: 'Region not found'}, status: 404) && return if region.nil?
      found_jobs = region.jobs
      found_jobs = found_jobs.where(organization_id: organization_id) if !organization_id.nil?
    else
      if !organization_id.nil?
        found_jobs = Job.joins(:provider).where(providers: {organization_id: organization_id})
      else
        found_jobs = Job.all
      end
    end
    found_jobs = found_jobs.where(state: state) if !state.nil?
    found_jobs = found_jobs.order(:updated_at).page(page).per(limit)

    found_jobs.each do |job|
      jobs.append(ApiHelper::job_to_json_v1({job: job,
                                             organization: job.organization,
                                             show_provider: show_provider,
                                             show_organization: show_organization,
                                             show_assignments: show_assignments,
                                             seeker: @seeker,
                                             show_allocations: show_allocations}))
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
    render(json: {code: 'jobs/not_found', message: 'Job not found'}, status: 404) && return if job == nil

    allocation = Allocation.find_by(job_id: id, seeker_id: @seeker.id)
    status_ok = !(job.state != 'public' && job.state != 'check')

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


    render(json: {code: 'jobs/incorrect_status', message: 'Der Job wurde leider in der Zwischenzeit deaktiviert oder vergeben.'}, status: 406) && return if !status_ok
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
  def show
    id = params[:id]
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_assignments = true?(params[:assignments])
    show_allocations = true?(params[:allocations])
    job = @seeker.jobs.find_by(id: id) if @seeker.class == Seeker
    job = Job.find_by(id: id) if @seeker.class != Seeker
    if job.blank?
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

    render json: ApiHelper::job_to_json_v1({job: job,
                                            organization: job.organization,
                                            show_provider: show_provider,
                                            show_organization: show_organization,
                                            show_assignments: show_assignments,
                                            seeker: @seeker,
                                            show_allocations: show_allocations}), status: 200
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

    found_allocations = found_allocations.where(state: status) if status != nil
    found_allocations = found_allocations.where(job_id: job_id) if job_id != nil
    found_allocations = found_allocations.page(page).per(limit)

    for allocation in found_allocations
      allocations.append(ApiHelper::allocation_with_job_to_json(allocation, allocation.job, show_provider, show_organization, show_seeker, show_assignments, @seeker))
    end

    render json: allocations, status: 200
  end

  def my
    if @seeker.present?
      organization_id = params[:organization_id]
      region_id = params[:region_id]
      status = params[:status] == nil ? nil : params[:status].to_i
      show_provider = true?(params[:provider])
      show_organization = true?(params[:organization])
      show_assignments = true?(params[:assignments])
      page = params[:page] == nil ? 1 : params[:page].to_i
      limit = params[:limit] == nil ? 10 : params[:limit].to_i
      show_allocations = true?(params[:allocations])

      state = Job::state_from_integer(status)

      jobs = []
      found_jobs = @seeker.jobs

      if region_id.present?
        region = Region.find_by(id: region_id)
        render(json: {code: 'jobs/not_found', message: 'Region not found'}, status: 404) && return if region.nil?
        found_jobs = region.jobs.joins(:seekers).where("seekers.id = ?", @seeker.id)
        found_jobs = found_jobs.where(organization_id: organization_id) if !organization_id.nil?
      else
        if !organization_id.nil?
          found_jobs = found_jobs.joins(:provider).where(providers: {organization_id: organization_id})
        end
      end
      found_jobs = found_jobs.where(state: state) if !state.nil?
      found_jobs = found_jobs.order(:updated_at).page(page).per(limit)
      found_jobs.each do |job|
        jobs.append(ApiHelper::job_to_json_v1({job: job,
                                               organization: job.organization,
                                               show_provider: show_provider,
                                               show_organization: show_organization,
                                               show_assignments: show_assignments,
                                               seeker: @seeker,
                                               show_allocations: show_allocations}))
      end
      render json: jobs, status: 200
    else
      render json: {code: 'jobs/not_found', message: 'User not found'}, status: 404
    end
  end
end
