require 'spec_helper'

describe Seeker::ReviewsController do

  it_behaves_like 'a protected controller', :seeker, :review, [:index, :new, :create, :edit, :update, :destroy] do
    let(:seeker)       { Fabricate(:seeker) }
    let(:provider)     { Fabricate(:provider, place: seeker.place) }
    let(:job)          { Fabricate(:job, provider: Fabricate(:provider, place: seeker.place)) }
    let(:review)       { Fabricate(:review, job: job, provider: provider) }
    let(:review_attrs) { Fabricate.attributes_for(:review, provider: provider) }
    let(:params)       { { job_id: job.id } }
  end

end
