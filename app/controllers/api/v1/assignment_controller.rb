class Api::V1::OrganizationsController < Api::V1::ApiController
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
end
