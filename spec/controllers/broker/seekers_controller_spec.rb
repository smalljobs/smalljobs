require_relative '../../spec_helper'

describe Broker::SeekersController, type: :controller do

  it_behaves_like 'a protected controller', :broker, :seeker, :all do
    let(:broker) { Fabricate(:broker_with_regions) }
    let(:seeker) { Fabricate(:seeker, place: broker.places.first) }
    let(:seeker_attrs) do
      attrs = Fabricate.attributes_for(:seeker, place: broker.places.first)
      attrs[:work_categories].map(&:save)
      attrs[:work_category_ids] = attrs[:work_categories].map(&:id)
      attrs
    end
  end

  describe '#index' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }

    before do
      Fabricate(:seeker, place: broker.places.first)
      Fabricate(:seeker, place: broker.places.last)
      Fabricate(:seeker, place: Fabricate(:place, zip: '9999'))
    end

    it 'shows only seekers in the broker regions' do
      get :index
      expect(assigns(:seekers).count).to eql(2)
    end
  end
end
