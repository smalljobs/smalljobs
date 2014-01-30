class JobsController < InheritedResources::Base
  load_resource :job

  protected

  def current_user
  end
end
