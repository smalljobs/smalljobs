class Broker::BrokersController < InheritedResources::Base
  before_filter :authenticate_broker!

  load_and_authorize_resource :region

  def new
    @broker = current_region.brokers.new
  end

  def edit
    broker
  end

  def create
    @broker = current_region.brokers.new(permitted_params)
    respond_to do |format|
      if @broker.save
        format.json { render json: { message: t('common.created')}, status: :ok }
      else
        format.json { render json: { error: @broker.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if broker.update(permitted_params)
        format.json { render json: { message: t('common.updated')}, status: :ok }
      else
        format.json { render json: { error: broker.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  protected

  def broker
    @broker ||= current_region.brokers.find_by(id: params[:id])
  end

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.require(:place).permit(:zip, :name, :longitude, :latitude)
  end

end

