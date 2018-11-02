require_relative '../spec_helper'
require 'main_subdomain'

describe MainSubdomain do
  it 'matches the www subdomain' do
    expect(MainSubdomain.matches?(double(subdomain: 'www'))).to be true
    expect(MainSubdomain.matches?(double(subdomain: 'other'))).to be false
  end
end
