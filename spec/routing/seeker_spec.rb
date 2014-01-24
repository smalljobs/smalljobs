require 'spec_helper'

describe 'routing to the seeker dashboard' do
  before do
    Fabricate(:region, name: 'Bremgarten')
  end

  it 'routes /seeker/dashboard to seeker/dashboard#show' do
    expect(get: 'http://bremgarten.example.com/seeker/dashboard').to route_to(
      controller: 'seeker/dashboards',
      action:     'show'
    )
  end
end
