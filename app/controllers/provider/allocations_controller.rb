class Provider::AllocationsController < InheritedResources::Base

  before_filter :authenticate_provider!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :allocation, through: :job

  skip_authorize_resource :allocation, only: :new

  actions :index

  protected

  # Returns currently signed in provider
  #
  # @return [Provider] currently signed in provider
  #
  def current_user
    current_provider
  end
end
