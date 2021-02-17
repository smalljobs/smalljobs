class Api::V1::ApiController < ApplicationController
  # before_action :authenticate, except: [:login, :register, :password_remind, :update_messages]
  before_action :check_status, only: [:create_assignment, :update_assignment, :apply]
  skip_before_filter :verify_authenticity_token

  # Access with and without authenticate
  ACCESS_CONTROLLER_ACTION = [['api/v1/jobs','show'],['api/v1/jobs', 'index']]


  def authenticate
    if ACCESS_CONTROLLER_ACTION.include?([params[:controller], params[:action]])
      authenticate_token
      return true
    else
      authenticate_token || render_unauthorized
    end
  end
  # Check if authentication token is valid
  #
  def authenticate_token
    token = get_token
    return false if token == nil

    expiration_date = token.expire_at || (token.created_at + 30.days)
    return false if expiration_date < DateTime.now

    @seeker = token.userable
  end

  # Return information about invalid access token
  #
  def render_unauthorized
    render json: {code: 'users/invalid', message: 'Invalid access token'}, status: 422
  end

  private

  def get_token
    authorization_header = request.authorization()
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      token = AccessToken.find_by(access_token: token)
    end
    token
  end

  def true?(obj)
    obj.to_s == 'true'
  end

  def check_status
    @seeker.status == 'active' || render_unauthorized_status
  end

end
