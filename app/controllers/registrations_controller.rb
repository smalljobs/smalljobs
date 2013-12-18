class RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def new
    if self.resource_name == :job_broker
      flash[:failure] = t('devise_views.no_broker_registration')
      redirect_to root_path
    else
      super
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :password, :password_confirmation, :firstname, :lastname, :street, :zip, :city, :date_of_birth, :email, :phone, :mobile, :contact_preference, :contact_availability, work_category_ids: [])
    end
  end

end
