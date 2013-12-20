require 'spec_helper'

describe 'routing to the broker dashboard' do
  it 'routes /broker/dashboard to broker/dashboard#index' do
    expect(get: '/broker/dashboard').to route_to(
      controller: 'broker/dashboards',
      action:     'show'
    )
  end
end
