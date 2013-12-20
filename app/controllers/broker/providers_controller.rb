class Broker::ProvidersController < InheritedResources::Base
  before_filter :authenticate_broker!
  load_and_authorize_resource :provider, through: :current_broker
end
