class Api::V1::OrganizationsController < Api::V1::ApiController
  # GET /api/market/organizations?region=1&active=true
  # Returns all available organizations
  # Optionally display organizations from specific region
  #
  def index
    region = nil

    if params[:region].present?
      region = Region.find_by(id: params[:region])
      if region.present?
        render(json: {code: 'market/not_found', message: 'Region not found'}, status: 404) && return
      end
    end

    active = params[:active] == nil || params[:active] == 'true' || params[:active] == true
    organizations = []

    if region.present?
      region.organizations.where(active: true).distinct.each do |organization|
        organizations.append(ApiHelper::organization_to_json(organization, region.id)) if organization.active == active
      end
    else
      Organization.where(active: active).find_each do |organization|
        organizations.append(ApiHelper::organization_to_json(organization, organization.regions.first.try(:id)))
      end
    end

    render json: organizations, status: 200
  end

  # GET /api/market/organizations/[id]
  # Returns organization details
  #
  def show
    organization = Organization.find_by(id: params[:id])
    unless organization.present?
      render(json: {code: 'market/not_found', message: 'Organization not found'}, status: 404) && return
    end
    render json: ApiHelper::organization_to_json(organization, organization.regions.first.id), status: 200
  end

end