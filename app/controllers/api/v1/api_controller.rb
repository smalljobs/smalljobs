class Api::V1::ApiController < ApplicationController
  before_action :authenticate, except: [:login, :register, :password_remind, :update_messages]
  before_action :check_status, only: [:create_assignment, :update_assignment, :apply]
  skip_before_filter :verify_authenticity_token

  # Access with and without authenticate
  ACCESS_CONTROLLER_ACTION = [['api/v1/jobs','show'],['api/v1/jobs', 'index']]


  def authenticate
    if ACCESS_CONTROLLER_ACTION.include?([params[:controller], params[:action]])
      puts 'auth 1'
      authenticate_token
      return true
    else
      puts 'auth 1'
      authenticate_token || render_unauthorized
    end
  end
  # Check if authentication token is valid
  #
  def authenticate_token
    token = get_token
    puts "authenticate_token:#{authenticate_token}"
    return false if token == nil

    expiration_date = token.expire_at || (token.created_at + 30.days)
    puts "EXP: #{expiration_date < DateTime.now}"
    return false if expiration_date < DateTime.now
    puts 'auth 3'
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
    puts "authorization_header: #{authorization_header}"
    if authorization_header != nil
      token = authorization_header.split(" ")[1]
      puts "token1: #{token}"
      token = AccessToken.find_by(access_token: token)
      puts "token2: #{token.inspect}"
    end
    puts "token3: #{token.inspect}"
    token
  end

  def true?(obj)
    obj.to_s == 'true'
  end

  def check_status
    @seeker.status == 'active' || render_unauthorized_status
  end

end
