require 'spec_helper'
require 'main_subdomain'

describe MainSubdomain do
  it 'matches the www subdomain' do
    expect(MainSubdomain.matches?(double(subdomain: 'www'))).to be_true
    expect(MainSubdomain.matches?(double(subdomain: 'other'))).to be_false
  end
end
