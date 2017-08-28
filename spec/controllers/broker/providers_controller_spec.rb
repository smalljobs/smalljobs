require_relative '../../spec_helper'

describe Broker::ProvidersController do

  it_behaves_like 'a protected controller', :broker, :provider, :all do
    let(:broker)         { Fabricate(:broker_with_regions) }
    let(:provider)       { Fabricate(:provider, place: broker.places.first) }
    let(:provider_attrs) { Fabricate.attributes_for(:provider, place: broker.places.first) }
  end

  describe '#index' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }

    before do
      Fabricate(:provider, place: broker.places.first)
      Fabricate(:provider, place: broker.places.last)
      Fabricate(:provider, place: Fabricate(:place, zip: '9999'))
    end

    it 'shows only providers in the broker regions' do
      get :index
      expect(assigns(:providers).count).to eql(2)
    end
  end
end
