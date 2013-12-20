require 'spec_helper'

describe Broker::DashboardsController do

  describe '#show' do
    context 'access control' do
      it 'is not accessible by an anonymous user' do
        xhr :get, :show
        expect(response.status).to eql(401)
      end

      it 'is not accessible by a provider' do
        authenticate(:provider, Fabricate(:provider))
        xhr :get, :show
        expect(response.status).to eql(401)
      end

      it 'is not accessible by a seeker' do
        authenticate(:seeker, Fabricate(:seeker))
        xhr :get, :show
        expect(response.status).to eql(401)
      end

      it 'is accessible by a broker' do
        authenticate(:broker, Fabricate(:broker))
        xhr :get, :show
        expect(response.status).to eql(200)
       end
    end

    context 'presenting the dashboard' do
      auth_broker(:broker) { Fabricate(:broker_with_regions) }

      let!(:provider_1) { Fabricate(:provider, zip: '1234') }
      let!(:provider_2) { Fabricate(:provider, zip: '1235') }

      let!(:seeker_1) { Fabricate(:seeker, zip: '1234') }
      let!(:seeker_2) { Fabricate(:seeker, zip: '1235') }

      before do
        xhr :get, :show
      end

      it 'gets the providers managed by this broker' do
        expect(assigns[:providers]).to match_array([provider_1, provider_2])
      end

      it 'gets the seekers managed by this broker' do
        expect(assigns[:seekers]).to match_array([seeker_1, seeker_2])
      end
    end

  end
end
