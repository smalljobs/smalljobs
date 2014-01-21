require 'spec_helper'

describe 'routing to the provider dashboard' do
  it 'routes /provider/dashboard to provider/dashboard#show' do
    expect(get: '/provider/dashboard').to route_to(
      controller: 'provider/dashboards',
      action:     'show'
    )
  end
end
