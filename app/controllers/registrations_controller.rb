class RegistrationsController < Devise::RegistrationsController

  protected

  def after_inactive_sign_up_path_for(resource)
    if !resource.confirmed?
      awaiting_confirmation_path
    elsif !resource.active?
      awaiting_activation_path
    else
      super
    end
  end

end
