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

  describe '#create' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }
    let(:provider) { Fabricate(:provider, place: broker.places.first) }

    it 'creates a job in the available state' do
      params = { format: :json }
      params[:job] = Fabricate.attributes_for(:job, provider: provider)

      post :create, params
      expect(Job.first.state).to eql('available')
    end
  end

  describe '#activate' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }
    let(:job) { Fabricate(:job, provider: provider) }

    context 'with a job in the broker region' do
      let(:provider) { Fabricate(:provider, place: broker.places.first) }

      it 'activates the job' do
        params = { format: :json, id: job.id }
        post :activate, params
        expect(job.reload.state).to eql('available')
      end
    end

    context 'with a job not in the broker region' do
      let(:provider) { Fabricate(:provider) }

      it 'does not activate the job' do
        params = { format: :json, id: job.id }
        post :activate, params
        expect(job.reload.state).to eql('created')
      end
    end
  end
end
