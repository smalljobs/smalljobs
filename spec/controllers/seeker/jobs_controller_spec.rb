require 'spec_helper'

describe Seeker::JobsController do

  it_behaves_like 'a protected controller', :seeker, :job, [:index, :show] do
    let(:seeker)    { Fabricate(:seeker) }
    let(:job)       { Fabricate(:job, provider: Fabricate(:provider, place: seeker.place)) }
    let(:job_attrs) { Fabricate.attributes_for(:job, provider: Fabricate(:provider, place: seeker.place)) }
  end

  describe '#index' do
    auth_seeker(:seeker) { Fabricate(:seeker) }

    before do
      Fabricate(:job, provider: Fabricate(:provider, place: seeker.place))
      Fabricate(:job, provider: Fabricate(:provider, place: seeker.place))
      Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))

      controller.stub(current_region: seeker.place.region)
    end

    it 'shows only jobs in the seekers regions' do
      get :index
      expect(assigns(:jobs).count).to eql(2)
    end
  end

end
