class Api::V1::Admin::SeekersController < Api::V1::ApiController
  # GET /api/users
  # Returns list of users.
  # Optionally you can retrieve list of users from defined organization.
  #  TODO PRZENIESC DO ADMINA
  def index
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
  def show
    user = Seeker.find_by(id: params[:id])
    if user == nil
      render json: {code: 'users/not_found', message: 'User not found'}, status: 404
      return
    end

    render json: ApiHelper::seeker_to_json(user), status: 200
  end
end