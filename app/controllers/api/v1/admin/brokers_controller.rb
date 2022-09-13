class Api::V1::Admin::BrokersController < Api::V1::Admin::ApiController
  before_action :set_broker, only: [:update]
  def update
    if @broker.present?
      if @broker.update(set_update_params)
        render json: {message: 'Broker updated successfully'}, status: 200
      else
        render json: {code: 'users/invalid', message: @broker.errors.first}, status: 422
      end
    else
      render(json: {code: 'users/not_found', message: 'Benutzer nicht gefunden'}, status: 404)
    end
  end

  private
  def update_params
    params.permit( :rc_id, :rc_username, :mobile, :email, :phone, :app_user_id)
  end

  def set_update_params
    user_params = update_params
    user_params[:ji_request] = true
    user_params
  end

  def set_broker
    #@broker = Broker.find_by(email: params[:email])
    @broker = Broker.find_by(id: params[:id])
  end
end
