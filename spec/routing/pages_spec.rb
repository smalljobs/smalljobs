require 'spec_helper'

describe 'routing to the pages' do
  it 'routes / to pages#home' do
    expect(get: '/').to route_to(
      controller: 'pages',
      action:     'home'
    )
  end

  it 'routes /sign_in to pages#sign_in' do
    expect(get: '/sign_in').to route_to(
      controller: 'pages',
      action:     'sign_in'
    )
  end

  it 'routes /confirm to pages#confirm' do
    expect(get: '/awaiting_confirmation').to route_to(
      controller: 'pages',
      action:     'awaiting_confirmation'
    )
  end

  it 'routes /activate to pages#activate' do
    expect(get: '/awaiting_activation').to route_to(
      controller: 'pages',
      action:     'awaiting_activation'
    )
  end

  it 'routes /about_us to pages#about_us' do
    expect(get: '/about_us').to route_to(
      controller: 'pages',
      action:     'about_us'
    )
  end

  it 'routes /privacy_policy to pages#home' do
    expect(get: '/privacy_policy').to route_to(
      controller: 'pages',
      action:     'privacy_policy'
    )
  end

  it 'routes /terms_of_service to pages#home' do
    expect(get: '/terms_of_service').to route_to(
      controller: 'pages',
      action:     'terms_of_service'
    )
  end
end
