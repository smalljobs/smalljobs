require 'spec_helper'

describe Provider::JobsController do

  it_behaves_like 'a protected controller', :provider, :job, :all do
    let(:provider)  { Fabricate(:provider) }
    let(:job)       { Fabricate(:job, provider: provider) }
    let(:job_attrs) { Fabricate.attributes_for(:job, provider: provider) }
  end

  describe '#index' do
    auth_provider(:provider) { Fabricate(:provider) }

    before do
      Fabricate(:job, provider: provider)
      Fabricate(:job, provider: provider)
      Fabricate(:job, provider: Fabricate(:provider))
    end

    it 'shows only jobs in the broker regions' do
      get :index
      expect(assigns(:jobs).count).to eql(2)
    end
  end

  describe '#create' do
    auth_provider(:provider) { Fabricate(:provider) }

    it 'creates a job with the current provider assigned' do
      params = { format: :json }
      params[:job] = Fabricate.attributes_for(:job)

      post :create, params
      expect(Job.first.provider).to eql(provider)
    end
  end
end
