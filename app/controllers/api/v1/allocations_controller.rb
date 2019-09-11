class Api::V1::AllocationsController < Api::V1::ApiController
  # GET /api/allocations?user_id=1&job_id=1&user=true&provider=true&organization=true&assignments=true&status=0&page=1&limit=10
  # Display allocations list
  # Optionally show/hide provider or organization info
  def index
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
      allocations.append(ApiHelper::allocation_with_job_to_json(allocation, allocation.job, show_provider, show_organization, show_seeker, show_assignments))
    end

    render json: allocations, status: 200
  end

end