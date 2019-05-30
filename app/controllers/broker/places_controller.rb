class Broker::PlacesController < InheritedResources::Base
  autocomplete :place, :zip

  before_filter :authenticate_broker!

  # actions :edit, :update
  load_and_authorize_resource :region

  def autocomplete_place_zip
    term = params[:term].downcase
    places = Place.where(
        'LOWER(places.zip) LIKE ? OR LOWER(places.name) LIKE ?',
        "%#{term}%", "%#{term}%"
    ).where(region_id: nil).order(:id).limit(10)
    render :json => places.map { |place| {:id => place.id, :label => place.full_name, :value => place.full_name} }
  end

  def add_place_to_region
    respond_to do |format|
      if @region.place
        format.json { render json: { message: "#{@place.zip} #{@place.name}"}, status: :ok }
      else
        format.json { render json: { error: @place.errors }, status: :unprocessable_entity }
      end
    end
  end

  def remove_from_region
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

