require_relative '../../spec_helper'

describe Broker::JobsController do

  it_behaves_like 'a protected controller', :broker, :job, :all do
    let(:broker)    { Fabricate(:broker_with_regions) }
    let(:job)       { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:job_attrs) { Fabricate.attributes_for(:job, provider: Fabricate(:provider, place: broker.places.first)) }
  end
end
