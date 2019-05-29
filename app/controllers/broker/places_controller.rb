class Broker::PlacesController < InheritedResources::Base

  before_filter :authenticate_broker!

  # actions :edit, :update
  load_and_authorize_resource :region
  load_and_authorize_resource :place, through: :current_broker, only: [:destroy]

  def create
    respond_to do |format|
      if @place = current_region.places.create(permitted_params)
        format.json { render json: { message: "#{@place.zip} #{@place.name}"}, status: :ok }
      else
        format.json { render json: { error: @place.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @place.destroy
        format.json { render json: { message: "#{@place.zip} #{@place.name}"}, status: :ok }
      else
        format.json { render json: { error: @place.errors }, status: :unprocessable_entity }
      end
    end
  end

  protected

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

