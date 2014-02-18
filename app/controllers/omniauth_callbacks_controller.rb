class OmniauthCallbacksController < ::Devise::OmniauthCallbacksController

  def facebook
    seeker = Seeker.find_for_facebook_oauth(request.env['omniauth.auth'], current_seeker)

    if seeker.persisted?
      if seeker.confirmed? && seeker.active?
        sign_in_and_redirect :seeker, seeker, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?

      elsif seeker.confirmed?
        set_flash_message(:notice, :inactive, kind: 'Facebook') if is_navigational_format?
        redirect_to root_url

      else
        set_flash_message(:notice, :unconfirmed, kind: 'Facebook') if is_navigational_format?
        redirect_to root_url
      end
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_seeker_registration_url
    end
  end

  private

  def current_user
    current_seeker
  end

end
