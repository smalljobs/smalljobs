class Api::V1::RegionsController < Api::V1::ApiController

  # GET /api/market/regions
  # Returns all available regions
  #
  def index
    regions = []
    Region.all.find_each do |region|
      regions.append(ApiHelper::region_to_json(region))
    end

    render json: regions, status: 200
  end

  # GET /api/market/regions/[region]
  # Returns single region
  #
  def show
    region = Region.find_by(id: params[:id])
    unless region
      render(json: {code: 'market/not_found', message: 'Region not found'}, status: 404) && return
    end
    render json: ApiHelper::region_to_json(region), status: 200
  end

end