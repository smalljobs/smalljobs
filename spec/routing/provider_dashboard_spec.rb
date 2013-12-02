require 'spec_helper'

describe 'routing to the provider dashboard' do
  it 'routes /job_providers/dashboard to provider_dashboard#index' do
    expect(get: '/job_providers/dashboard').to route_to(
      controller: 'provider_dashboard',
      action:     'index'
    )
  end
end
