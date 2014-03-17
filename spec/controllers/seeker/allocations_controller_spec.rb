require 'spec_helper'

describe Seeker::AllocationsController do

  it_behaves_like 'a protected controller', :seeker, :allocation, :index do
    let(:seeker)           { Fabricate(:seeker) }
    let(:job)              { Fabricate(:job, provider: Fabricate(:provider, place: seeker.place)) }
    let(:allocation)       { Fabricate(:allocation, job: job) }
    let(:allocation_attrs) { Fabricate.attributes_for(:allocation) }
    let(:params)           { { job_id: job.id } }
  end

end
