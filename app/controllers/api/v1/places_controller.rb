class Api::V1::PlacesController < Api::V1::ApiController

  def index
    places = Places.all
    places_downloaded = []
    places.each do |place|
      places_downloaded << ApiHelper::place_to_json(place)
    end
    render json: {places: places}
  end

  def show
    place = Places.find_by(id: params[:id])
    render json: ApiHelper::place_to_json(place)
  end

end