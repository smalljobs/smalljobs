require 'spec_helper'

describe Broker::OrganizationsController do

  it_behaves_like 'a protected controller', :broker, :organization, [:edit, :update] do
    let(:place)        { Fabricate(:place) }
    let(:broker)       { Fabricate(:broker_with_regions, place: place) }
    let(:organization) { broker.organizations.first }

    before do
      controller.stub(current_region: organization.regions.first)
    end
  end

  describe '#edit' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }
    let(:organization) { broker.organizations.first }

    it 'edits the current region organization' do
      get :edit
      expect(assigns(:organization)).to eql(organization)
    end
  end

  describe '#update' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }
    let(:organization) { broker.organizations.first }

    it 'updates the current region organization' do
      params = { format: :json }
      params[:organization] = organization.attributes
      params[:organization][:name] = 'Testorg'

      patch :update, params
      expect(organization.reload.name).to eql('Testorg')
    end

    it 'redirects the user to the dashboard after editing' do
      params = { format: :json }
      params[:organization] = organization.attributes
      params[:organization][:name] = 'Testorg'

      patch :update, params
      expect(response.location).to eql(broker_dashboard_url)
    end

  end
end
