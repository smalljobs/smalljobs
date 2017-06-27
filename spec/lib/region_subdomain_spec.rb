require 'spec_helper'
require 'region_subdomain'

describe RegionSubdomain do
  before do
    Fabricate(:region, name: 'Bremgarten AG')
    Fabricate(:region, name: 'Zürich')
  end

  it 'matches existing regions' do
    expect(RegionSubdomain.matches?(double(subdomain: 'bremgarten-ag'))).to be_true
    expect(RegionSubdomain.matches?(double(subdomain: 'zuerich'))).to be_true
    expect(RegionSubdomain.matches?(double(subdomain: 'www'))).to be_false
  end
end
