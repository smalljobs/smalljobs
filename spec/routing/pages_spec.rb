require 'spec_helper'

describe 'routing to the pages' do
  before do
    Fabricate(:region, name: 'Bremgarten')
  end

  it 'routes / to pages#join_us' do
    expect(get: 'http://www.example.com/join_us').to route_to(
      controller: 'pages',
      action:     'join_us'
    )
  end

  it 'routes /sign_in to pages#sign_in' do
    expect(get: 'http://bremgarten.example.com/sign_in').to route_to(
      controller: 'pages',
      action:     'sign_in'
    )
  end

  it 'routes /about_us to pages#about_us' do
    expect(get: 'http://www.example.com/about_us').to route_to(
      controller: 'pages',
      action:     'about_us'
    )
  end

  it 'routes /privacy_policy to pages#home' do
    expect(get: 'http://www.example.com/privacy_policy').to route_to(
      controller: 'pages',
      action:     'privacy_policy'
    )
  end

  it 'routes /terms_of_service to pages#home' do
    expect(get: 'http://www.example.com/terms_of_service').to route_to(
      controller: 'pages',
      action:     'terms_of_service'
    )
  end
end
