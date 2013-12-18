class ConfirmationsController < Devise::ConfirmationsController

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end

  def set_flash_message(key, kind, options = {})
    if kind == :confirmed && self.resource.active?
      kind = "#{ kind }_without_activation".intern
    end

    super(key, kind, options)
  end

end
