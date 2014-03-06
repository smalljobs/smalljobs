require 'spec_helper'

describe Broker::ProposalsController do

  it_behaves_like 'a protected controller', :broker, :proposal, [:index, :new, :edit, :update, :destroy] do
    let(:broker)         { Fabricate(:broker_with_regions) }
    let(:job)            { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:proposal)       { Fabricate(:proposal, job: job) }
    let(:proposal_attrs) { Fabricate.attributes_for(:proposal) }
    let(:params)         { { job_id: job.id } }
  end

end
