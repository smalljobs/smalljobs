class Broker::PlacesController < InheritedResources::Base
  autocomplete :place, :zip

  before_filter :authenticate_broker!

  load_and_authorize_resource :region

  def autocomplete_place_zip
    term = params[:term].downcase
    places = Place.where('LOWER(places.zip) LIKE :term OR LOWER(places.name) LIKE :term', term: "%#{term}%")
                  .where(region_id: nil)
                  .where(country_id: @region.country_id)
                  .order(:id).limit(10)
    render :json => places.map { |place| {:id => place.id, :label => place.full_name, :value => place.full_name} }
  end

  def add_place_to_region
    @place = Place.find(params[:id])
    respond_to do |format|
      if @place.update(region_id: current_region.id)
        format.json { render json: { message: "#{@place.zip} #{@place.name}"}, status: :ok }
      else
        format.json { render json: { error: @place.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def remove_from_region
    @place = current_region.places.find_by(id: params[:id])
    respond_to do |format|
      if @place.update(region_id: nil)
        format.json { render json: { message: "#{@place.zip} #{@place.name}"}, status: :ok }
      else
        format.json { render json: { error: @place.errors.full_messages }, status: :unprocessable_entity }
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

