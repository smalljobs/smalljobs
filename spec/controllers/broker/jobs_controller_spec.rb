require 'spec_helper'

describe Broker::JobsController do

  it_should_behave_like 'a protected controller', :broker, :job, :all, {
    broker:    -> { Fabricate(:broker_with_regions) },
    job:       -> { Fabricate(:job) },
    job_attrs: -> { Fabricate.attributes_for(:job) }
  }

  describe '#index' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }

    before do
      Fabricate(:job, provider: Fabricate(:provider, zip: '1234'))
      Fabricate(:job, provider: Fabricate(:provider, zip: '1235'))
      Fabricate(:job, provider: Fabricate(:provider, zip: '9999'))
    end

    it 'shows only jobs in the broker regions' do
      get :index
      #TODO: expect(assigns(:jobs).count).to eql(2)
    end
  end
end
