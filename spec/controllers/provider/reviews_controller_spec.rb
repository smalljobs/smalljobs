require 'spec_helper'

describe Provider::ReviewsController do

  it_behaves_like 'a protected controller', :provider, :review, [:index, :new, :create, :edit, :update, :destroy] do
    let(:provider)     { Fabricate(:provider) }
    let(:job)          { Fabricate(:job, provider: provider) }
    let(:review)       { Fabricate(:review, job: job) }
    let(:review_attrs) { Fabricate.attributes_for(:review) }
    let(:params)       { { job_id: job.id } }
  end

end
