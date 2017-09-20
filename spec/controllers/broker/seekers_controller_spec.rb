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
end
