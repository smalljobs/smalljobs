require 'spec_helper'

describe 'routing to the provider dashboard' do
  before do
    Fabricate(:region, name: 'Bremgarten')
  end

  it 'routes /provider/dashboard to provider/dashboard#show' do
    expect(get: 'http://bremgarten.example.com/provider/dashboard').to route_to(
      controller: 'provider/dashboards',
      action:     'show'
    )
  end
end
