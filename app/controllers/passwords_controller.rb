class PasswordsController < Devise::PasswordsController
  def new
    super
  end

  def create
    if !Broker.find_by(email: resource_params[:email]).nil?
      self.resource = Broker.send_reset_password_instructions(resource_params)
    else
      self.resource = resource_class.send_reset_password_instructions(resource_params)
    end

    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def edit
    super
  end

  def update
    super
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    sign_in_path
  end
end
