require 'spec_helper'

describe 'routing to the broker dashboard' do
  it 'routes /broker/dashboard to broker/dashboard#show' do
    expect(get: '/broker/dashboard').to route_to(
      controller: 'broker/dashboards',
      action:     'show'
    )
  end
end

describe 'routing to the broker provider management' do
  it 'routes /broker/providers to broker/providers#index' do
    expect(get: '/broker/providers').to route_to(
      controller: 'broker/providers',
      action:     'index'
    )
  end

  it 'routes /broker/providers/new to broker/providers#new' do
    expect(get: '/broker/providers/new').to route_to(
      controller: 'broker/providers',
      action:     'new'
    )
  end

  it 'routes posting to /broker/providers to broker/providers#create' do
    expect(post: '/broker/providers').to route_to(
      controller: 'broker/providers',
      action:     'create'
    )
  end

  it 'routes /broker/providers/12 to broker/providers#show' do
    expect(get: '/broker/providers/12').to route_to(
      controller: 'broker/providers',
      action:     'show',
      id:         '12'
    )
  end

  it 'routes /broker/providers/12/edit to broker/providers#edit' do
    expect(get: '/broker/providers/12/edit').to route_to(
      controller: 'broker/providers',
      action:     'edit',
      id:         '12'
    )
  end

  it 'routes patching to /broker/providers/12 to broker/providers#update' do
    expect(patch: '/broker/providers/12').to route_to(
      controller: 'broker/providers',
      action:     'update',
      id:         '12'
    )
  end

  it 'routes deleting to /broker/providers/12 to broker/providers#destroy' do
    expect(delete: '/broker/providers/12').to route_to(
      controller: 'broker/providers',
      action:     'destroy',
      id:         '12'
    )
  end
end
