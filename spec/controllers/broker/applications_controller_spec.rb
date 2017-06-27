require 'spec_helper'

describe Broker::ApplicationsController do

  it_behaves_like 'a protected controller', :broker, :application, [:index, :edit, :update, :destroy] do
    let(:broker)            { Fabricate(:broker_with_regions) }
    let(:job)               { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:application)       { Fabricate(:application, job: job) }
    let(:application_attrs) { Fabricate.attributes_for(:application) }
    let(:params)            { { job_id: job.id } }
  end

end
