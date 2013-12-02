class OmniauthCallbacksController < ::Devise::OmniauthCallbacksController

  def facebook
    job_seeker = JobSeeker.find_for_facebook_oauth(request.env['omniauth.auth'], current_job_seeker)

    if job_seeker.persisted?
      sign_in_and_redirect job_seeker, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_job_seeker_registration_url
    end
  end

end
