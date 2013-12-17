class ConfirmationsController < Devise::ConfirmationsController

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end

end
