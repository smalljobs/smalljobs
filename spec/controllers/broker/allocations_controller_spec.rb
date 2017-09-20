require_relative '../../spec_helper'

describe Broker::AllocationsController, type: :controller do

  it_behaves_like 'a protected controller', :broker, :allocation, [:edit, :update, :destroy] do
    let(:broker)            { Fabricate(:broker_with_regions) }
    let(:job)               { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:allocation)        { Fabricate(:allocation, job: job) }
    let(:allocation_attrs)  { Fabricate.attributes_for(:allocation) }
    let(:params)            { { job_id: job.id } }
  end

end
