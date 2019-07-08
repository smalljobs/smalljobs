class Api::V1::ApiController < ApplicationController
  before_action :authenticate, except: [:login, :register, :password_remind, :update_messages]
  skip_before_filter :verify_authenticity_token



  def authenticate
    authenticate_token || render_unauthorized
  end
  # Check if authentication token is valid
  #
  def authenticate_token
    token = get_token
    return false if token == nil

    expiration_date = token.expire_at || (token.created_at + 30.days)
    return false if expiration_date < DateTime.now

    @seeker = token.seeker
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

end