require_relative '../../spec_helper'

describe Provider::AllocationsController do

  it_behaves_like 'a protected controller', :provider, :allocation, :index do
    let(:provider)          { Fabricate(:provider) }
    let(:job)               { Fabricate(:job, provider: provider) }
    let(:allocation)        { Fabricate(:allocation, job: job) }
    let(:allocation_attrs)  { Fabricate.attributes_for(:allocation) }
    let(:params)            { { job_id: job.id } }
  end

end
