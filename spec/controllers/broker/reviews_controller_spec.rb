require 'spec_helper'

describe Broker::ReviewsController do

  it_behaves_like 'a protected controller', :broker, :review, [:index, :new, :create, :edit, :update, :destroy] do
    let(:broker)       { Fabricate(:broker_with_regions) }
    let(:job)          { Fabricate(:job, provider: Fabricate(:provider, place: broker.places.first)) }
    let(:review)       { Fabricate(:review, job: job) }
    let(:review_attrs) { Fabricate.attributes_for(:review) }
    let(:params)       { { job_id: job.id } }
  end

end
