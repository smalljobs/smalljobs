class Api::V1::AssignmentsController < Api::V1::ApiController
  before_action :set_assignment, only: [:show, :destroy, :update]

# GET /api/v1/assignments?organization_id=1&user_id=1&provider_id=1&status=1&user=true&provider=true&organization=true&job=true&page=1&limit=10
# Returns list of assignments
# Optionally you can retrieve list of assignments from defined organization
#
  def index
    available_statuses = [0,1]
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

    state = available_statuses[status] if status.present?

    assignments = []
    found_assignments = []

    if organization_id == nil
      found_assignments = Assignment.all
    else
      found_assignments = Assignment.joins(:provider).where(providers: {organization_id: organization_id})
    end
    found_assignments = found_assignments.where(status: state) if state != nil
    found_assignments = found_assignments.where(seeker_id: seeker_id) if seeker_id != nil
    found_assignments = found_assignments.where(provider_id: provider_id) if provider_id != nil
    found_assignments = found_assignments.page(page).per(limit)

    for assignment in found_assignments do
      assignments.append(
          ApiHelper::assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job)
      )
    end

    render json: assignments, status: 200
  end


# GET /api/assignments/[id]?user=true&provider=true&organization=true&job=true
# Display assignment details
# Optionally show/hide user, emploter or organization info
#
  def show
    show_provider = true?(params[:provider])
    show_organization = true?(params[:organization])
    show_seeker = true?(params[:user])
    show_job = true?(params[:job])
    render(json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404) && return if @assignment == nil
    render json: ApiHelper::assignment_with_data_to_json(@assignment, show_provider, show_organization, show_seeker, show_job)
  end

# POST /api/assignments
# Create new assignment
#
  def create
    start_datetime = params[:start_timestamp]
    start_datetime = DateTime.strptime(start_datetime, '%s') if start_datetime != nil

    stop_datetime = params[:stop_timestamp]
    stop_datetime = DateTime.strptime(stop_datetime, '%s') if stop_datetime != nil

    duration = params[:duration]
    duration = duration.to_i if duration != nil

    status = case params[:status].to_i
             when 0
               :active
             else
               :finished
             end

    assignment = Assignment.new(
      status: status,
      job_id: params[:job_id],
      seeker_id: params[:user_id],
      provider_id: params[:provider_id],
      feedback: params[:message],
      payment: params[:payment],
      start_time: start_datetime,
      end_time: stop_datetime,
      duration: duration
    )

    render(json: {code: 'assignments/invalid', message: assignment.errors.first}, status: 422) && return unless assignment.save
    render json: ApiHelper::assignment_to_json(assignment), status: 201
  end

# PATCH /api/assignments/[id]
# Update assignment data
#
  def update
    render(json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404) && return if @assignment == nil
    data = {}
    data[:status] = case params[:status].to_i
                    when 0
                      :active
                    else
                      :finished
                    end
    data[:feedback] = params[:message] if params[:message] != nil
    data[:start_time] = DateTime.strptime(params[:start_timestamp], '%s') if params[:start_timestamp] != nil
    data[:end_time] = DateTime.strptime(params[:stop_timestamp], '%s') if params[:stop_timestamp] != nil
    data[:duration] = params[:duration].to_i if params[:duration] != nil
    data[:payment] = params[:payment].to_f if params[:payment] != nil

    if @assignment.update(data)
      render json: ApiHelper::assignment_to_json(@assignment), status: 200
    else
      render json: {code: 'assignments/invalid', message: @assignment.errors.first}, status: 422
    end
  end

# DELETE /api/assignments/[id]
# Delete assignment
# User can destroy only own assignments
#
  def destroy
    render(json: {code: 'assignments/not_found', message: 'Assignment not found'}, status: 404) && return if @assignment == nil
    render(json: {code: 'assignments/invalid', message: 'Assignment not owned'}, status: 422) && return if @assignment.seeker_id != @seeker.id
    @assignment.destroy!
    render json: {message: 'Assignment deleted.', id: params[:id]}
  end

  private

  def set_assignment
    @assignment = Assignment.find_by(id: params[:id])
  end

end
