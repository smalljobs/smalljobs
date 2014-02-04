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

  context 'routing to the provider job management' do
    it 'routes /provider/jobs to provider/jobs#index' do
      expect(get: 'http://bremgarten.example.com/provider/jobs').to route_to(
        controller: 'provider/jobs',
        action:     'index'
      )
    end

    it 'routes /provider/jobs/new to provider/jobs#new' do
      expect(get: 'http://bremgarten.example.com/provider/jobs/new').to route_to(
        controller: 'provider/jobs',
        action:     'new'
      )
    end

    it 'routes posting to /provider/jobs to provider/jobs#create' do
      expect(post: 'http://bremgarten.example.com/provider/jobs').to route_to(
        controller: 'provider/jobs',
        action:     'create'
      )
    end

    it 'routes /provider/jobs/12 to provider/jobs#show' do
      expect(get: 'http://bremgarten.example.com/provider/jobs/12').to route_to(
        controller: 'provider/jobs',
        action:     'show',
        id:         '12'
      )
    end

    it 'routes /provider/jobs/12/edit to provider/jobs#edit' do
      expect(get: 'http://bremgarten.example.com/provider/jobs/12/edit').to route_to(
        controller: 'provider/jobs',
        action:     'edit',
        id:         '12'
      )
    end

    it 'routes patching to /provider/jobs/12 to provider/jobs#update' do
      expect(patch: 'http://bremgarten.example.com/provider/jobs/12').to route_to(
        controller: 'provider/jobs',
        action:     'update',
        id:         '12'
      )
    end

    it 'routes deleting to /provider/jobs/12 to provider/jobs#destroy' do
      expect(delete: 'http://bremgarten.example.com/provider/jobs/12').to route_to(
        controller: 'provider/jobs',
        action:     'destroy',
        id:         '12'
      )
    end
  end
end
