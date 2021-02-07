class Api::V1::Admin::ApiController < Api::V1::ApiController
  private

  def authenticate_token
    token = get_token
    return false if token == nil

    expiration_date = token.expire_at || (token.created_at + 30.days)
    return false if expiration_date < DateTime.now

    @admin = token.userable
    return false if !@admin.is_a?(Admin)
    @admin
  end

end
