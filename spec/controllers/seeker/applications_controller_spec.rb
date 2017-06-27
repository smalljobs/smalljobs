require 'spec_helper'

describe Seeker::ApplicationsController do

  it_behaves_like 'a protected controller', :seeker, :application, [:index, :new, :create, :edit, :update, :destroy] do
    let(:seeker)            { Fabricate(:seeker) }
    let(:job)               { Fabricate(:job, provider: Fabricate(:provider, place: seeker.place)) }
    let(:application)       { Fabricate(:application, job: job, seeker: seeker) }
    let(:application_attrs) { Fabricate.attributes_for(:application, seeker: seeker) }
    let(:params)            { { job_id: job.id } }
  end

end
