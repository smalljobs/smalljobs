require 'securerandom'
class AccessToken < ActiveRecord::Base
  belongs_to :seeker
  before_create :set_access_token
  before_create :set_refresh_token

  private
  def set_access_token
    return if access_token.present?
    token = generate_auth_token
    while AccessToken.exists?(access_token: token)
      token = generate_auth_token
    end

    self.access_token = token
  end

  def set_refresh_token
    return if refresh_token.present?
    token = generate_auth_token
    while AccessToken.exists?(refresh_token: token)
      token = generate_auth_token
    end

    self.refresh_token = token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/-/,'')
  end
end