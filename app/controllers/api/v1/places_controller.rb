class Api::V1::PlacesController < Api::V1::ApiController

  def index
    page = params[:page] == nil ? 1 : params[:page].to_i
    limit = params[:limit] == nil ? 5000 : params[:limit].to_i

    places = Place.all.page(page).per(limit)
    places.map{ |place| ApiHelper::place_to_json(place) }
    render json: {places: places}
  end

  def show
    place = Place.find_by(id: params[:id])
    return render(json: {code: 'places/not_found', message: 'Place not found'}, status: 404) if place.blank?
    render json: ApiHelper::place_to_json(place)
  end

end