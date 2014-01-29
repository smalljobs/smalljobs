require 'spec_helper'

describe Broker::JobsController do

  it_behaves_like 'a protected controller', :broker, :job, :all do
    let(:broker)    { Fabricate(:broker_with_regions) }
    let(:job)       { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:job_attrs) { Fabricate.attributes_for(:job, provider: Fabricate(:provider, place: broker.places.first)) }
  end

  describe '#index' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }

    before do
      Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first))
      Fabricate(:job, provider: Fabricate(:provider, place: broker.places.last))
      Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))
    end

    it 'shows only jobs in the broker regions' do
      get :index
      expect(assigns(:jobs).count).to eql(2)
    end
  end
end
