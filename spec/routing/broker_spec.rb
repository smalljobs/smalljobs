require 'spec_helper'

describe 'routing to the broker dashboard' do
  it 'routes /broker/dashboard to broker/dashboard#show' do
    expect(get: '/broker/dashboard').to route_to(
      controller: 'broker/dashboards',
      action:     'show'
    )
  end
end

describe 'routing to the broker seeker management' do
  it 'routes /broker/seekers to broker/seekers#index' do
    expect(get: '/broker/seekers').to route_to(
      controller: 'broker/seekers',
      action:     'index'
    )
  end

  it 'routes /broker/seekers/new to broker/seekers#new' do
    expect(get: '/broker/seekers/new').to route_to(
      controller: 'broker/seekers',
      action:     'new'
    )
  end

  it 'routes posting to /broker/seekers to broker/seekers#create' do
    expect(post: '/broker/seekers').to route_to(
      controller: 'broker/seekers',
      action:     'create'
    )
  end

  it 'routes /broker/seekers/12 to broker/seekers#show' do
    expect(get: '/broker/seekers/12').to route_to(
      controller: 'broker/seekers',
      action:     'show',
      id:         '12'
    )
  end

  it 'routes /broker/seekers/12/edit to broker/seekers#edit' do
    expect(get: '/broker/seekers/12/edit').to route_to(
      controller: 'broker/seekers',
      action:     'edit',
      id:         '12'
    )
  end

  it 'routes patching to /broker/seekers/12 to broker/seekers#update' do
    expect(patch: '/broker/seekers/12').to route_to(
      controller: 'broker/seekers',
      action:     'update',
      id:         '12'
    )
  end

  it 'routes deleting to /broker/seekers/12 to broker/seekers#destroy' do
    expect(delete: '/broker/seekers/12').to route_to(
      controller: 'broker/seekers',
      action:     'destroy',
      id:         '12'
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

describe 'routing to the broker job management' do
  it 'routes /broker/jobs to broker/jobs#index' do
    expect(get: '/broker/jobs').to route_to(
      controller: 'broker/jobs',
      action:     'index'
    )
  end

  it 'routes /broker/jobs/new to broker/jobs#new' do
    expect(get: '/broker/jobs/new').to route_to(
      controller: 'broker/jobs',
      action:     'new'
    )
  end

  it 'routes posting to /broker/jobs to broker/jobs#create' do
    expect(post: '/broker/jobs').to route_to(
      controller: 'broker/jobs',
      action:     'create'
    )
  end

  it 'routes /broker/jobs/12 to broker/jobs#show' do
    expect(get: '/broker/jobs/12').to route_to(
      controller: 'broker/jobs',
      action:     'show',
      id:         '12'
    )
  end

  it 'routes /broker/jobs/12/edit to broker/jobs#edit' do
    expect(get: '/broker/jobs/12/edit').to route_to(
      controller: 'broker/jobs',
      action:     'edit',
      id:         '12'
    )
  end

  it 'routes patching to /broker/jobs/12 to broker/jobs#update' do
    expect(patch: '/broker/jobs/12').to route_to(
      controller: 'broker/jobs',
      action:     'update',
      id:         '12'
    )
  end

  it 'routes deleting to /broker/jobs/12 to broker/jobs#destroy' do
    expect(delete: '/broker/providers/12').to route_to(
      controller: 'broker/providers',
      action:     'destroy',
      id:         '12'
    )
  end
end
