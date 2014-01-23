require 'spec_helper'

describe Broker::JobsController do

  it_should_behave_like 'a protected controller', :broker, :job, :all, {
    broker:    -> { Fabricate(:broker_with_regions) },
    job:       -> { Fabricate(:job) },
    job_attrs: -> { Fabricate.attributes_for(:job) }
  }

end
