require 'spec_helper'

describe 'routing to the seeker dashboard' do
  it 'routes /job_seekers/dashboard to seeker_dashboard#index' do
    expect(get: '/job_seekers/dashboard').to route_to(
      controller: 'seeker_dashboard',
      action:     'index'
    )
  end
end
