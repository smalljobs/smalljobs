class OmniauthCallbacksController < ::Devise::OmniauthCallbacksController

  def facebook
    job_seeker = JobSeeker.find_for_facebook_oauth(request.env['omniauth.auth'], current_job_seeker)

    if job_seeker.persisted?
      if job_seeker.confirmed? && job_seeker.activated?
        sign_in_and_redirect :job_seeker, job_seeker, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?

      elsif job_seeker.confirmed?
        redirect_to activate_url

      else
        redirect_to confirm_url
      end
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_job_seeker_registration_url
    end
  end

end
