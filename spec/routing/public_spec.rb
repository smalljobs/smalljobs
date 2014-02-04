require 'spec_helper'

describe 'public routes' do
  before do
    Fabricate(:region, name: 'Bremgarten')
  end

  it 'routes /jobs/12 to jobs#show' do
    expect(get: 'http://bremgarten.example.com/jobs/12').to route_to(
      controller: 'jobs',
      action:     'show',
      id:         '12'
    )
  end

end
