require_relative '../spec_helper'

describe RegionsController, type: :controller do

  describe '#index' do
    before do
      Fabricate.times(5, :organization)
    end

    it 'shows all organizations' do
      get :index
      expect(assigns(:organizations).count).to eql(5)
    end
  end

  describe '#show' do
    let(:org) { Fabricate(:org_bremgarten) }

    before do
      controller.stub(current_region: org.regions.first)
      Fabricate.times(2, :job, provider: Fabricate(:provider, place: org.regions.first.places.first))
      Fabricate.times(2, :job)
    end

    it 'shows the organization of the current region' do
      get :show
      expect(assigns(:organization).name).to eql('Jugendarbeit Bremgarten')
      expect(assigns(:jobs).count).to eql(2)
    end
  end
end
