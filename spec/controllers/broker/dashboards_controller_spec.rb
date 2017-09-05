require_relative '../../spec_helper'

describe Broker::DashboardsController, type: :controller do
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
  end
end
