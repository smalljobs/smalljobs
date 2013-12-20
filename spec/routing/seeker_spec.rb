require 'spec_helper'

describe 'routing to the seeker dashboard' do
  it 'routes /seeker/dashboard to seeker/dashboard#index' do
    expect(get: '/seeker/dashboard').to route_to(
      controller: 'seeker/dashboards',
      action:     'show'
    )
  end
end
