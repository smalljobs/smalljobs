require 'spec_helper'

describe Seeker::ProposalsController do

  it_behaves_like 'a protected controller', :seeker, :proposal, :index do
    let(:seeker)         { Fabricate(:seeker) }
    let(:job)            { Fabricate(:job, provider: Fabricate(:provider, place: seeker.place)) }
    let(:proposal)       { Fabricate(:proposal, job: job) }
    let(:proposal_attrs) { Fabricate.attributes_for(:proposal) }
    let(:params)         { { job_id: job.id } }
  end

end
