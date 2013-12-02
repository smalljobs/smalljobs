require 'spec_helper'

describe 'routing to the broker dashboard' do
  it 'routes /job_brokers/dashboard to broker_dashboard#index' do
    expect(get: '/job_brokers/dashboard').to route_to(
      controller: 'broker_dashboard',
      action:     'index'
    )
  end
end
