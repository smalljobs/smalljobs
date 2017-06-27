require 'spec_helper'

describe 'routing to the seeker dashboard' do
  before do
    Fabricate(:region, name: 'Bremgarten')
  end

  it 'routes /seeker/dashboard to seeker/dashboard#show' do
    expect(get: 'http://bremgarten.example.com/seeker/dashboard').to route_to(
      controller: 'seeker/dashboards',
      action:     'show'
    )
  end

  context 'routing to the seeker job management' do
    it 'routes /seeker/jobs to seeker/jobs#index' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs').to route_to(
        controller: 'seeker/jobs',
        action:     'index'
      )
    end

    it 'routes /seeker/jobs/12 to seeker/jobs#show' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12').to route_to(
        controller: 'seeker/jobs',
        action:     'show',
        id:         '12'
      )
    end
  end

  context 'routing to the seeker job proposals management' do
    it 'routes /seeker/jobs/12/proposals to seeker/proposals#index' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/proposals').to route_to(
        controller: 'seeker/proposals',
        action:     'index',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/proposals/99 to seeker/proposals#show' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/proposals/99').to route_to(
        controller: 'seeker/proposals',
        action:     'show',
        job_id:     '12',
        id:         '99'
      )
    end
  end

  context 'routing to the seeker job applications management' do
    it 'routes /seeker/jobs/12/applications to seeker/applications#index' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/applications').to route_to(
        controller: 'seeker/applications',
        action:     'index',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/applications/new to seeker/applications#new' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/applications/new').to route_to(
        controller: 'seeker/applications',
        action:     'new',
        job_id:     '12'
      )
    end

    it 'routes posting to /seeker/jobs/12/applications to seeker/applications#create' do
      expect(post: 'http://bremgarten.example.com/seeker/jobs/12/applications').to route_to(
        controller: 'seeker/applications',
        action:     'create',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/applications/99/edit to seeker/jobs#edit' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/applications/99/edit').to route_to(
        controller: 'seeker/applications',
        action:     'edit',
        job_id:     '12',
        id:         '99'
      )
    end

    it 'routes patching to /seeker/jobs/12/applications/99/ to seeker/jobs#update' do
      expect(patch: 'http://bremgarten.example.com/seeker/jobs/12/applications/99').to route_to(
        controller: 'seeker/applications',
        action:     'update',
        job_id:     '12',
        id:         '99'
      )
    end

    it 'routes deleting to /seeker/jobs/12/applications/99/ to seeker/jobs#destroy' do
      expect(delete: 'http://bremgarten.example.com/seeker/jobs/12/applications/99').to route_to(
        controller: 'seeker/applications',
        action:     'destroy',
        job_id:     '12',
        id:         '99'
      )
    end
  end

  context 'routing to the seeker job allocations management' do
    it 'routes /seeker/jobs/12/allocations to seeker/allocations#index' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/allocations').to route_to(
        controller: 'seeker/allocations',
        action:     'index',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/allocations/99 to seeker/allocations#show' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/allocations/99').to route_to(
        controller: 'seeker/allocations',
        action:     'show',
        job_id:     '12',
        id:         '99'
      )
    end
  end

  context 'routing to the seeker job reviews management' do
    it 'routes /seeker/jobs/12/reviews to seeker/reviews#index' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/reviews').to route_to(
        controller: 'seeker/reviews',
        action:     'index',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/reviews/new to seeker/reviews#new' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/reviews/new').to route_to(
        controller: 'seeker/reviews',
        action:     'new',
        job_id:     '12'
      )
    end

    it 'routes posting to /seeker/jobs/12/reviews to seeker/reviews#create' do
      expect(post: 'http://bremgarten.example.com/seeker/jobs/12/reviews').to route_to(
        controller: 'seeker/reviews',
        action:     'create',
        job_id:     '12'
      )
    end

    it 'routes /seeker/jobs/12/reviews/99/edit to seeker/jobs#edit' do
      expect(get: 'http://bremgarten.example.com/seeker/jobs/12/reviews/99/edit').to route_to(
        controller: 'seeker/reviews',
        action:     'edit',
        job_id:     '12',
        id:         '99'
      )
    end

    it 'routes patching to /seeker/jobs/12/reviews/99/ to seeker/jobs#update' do
      expect(patch: 'http://bremgarten.example.com/seeker/jobs/12/reviews/99').to route_to(
        controller: 'seeker/reviews',
        action:     'update',
        job_id:     '12',
        id:         '99'
      )
    end

    it 'routes deleting to /seeker/jobs/12/reviews/99/ to seeker/jobs#destroy' do
      expect(delete: 'http://bremgarten.example.com/seeker/jobs/12/reviews/99').to route_to(
        controller: 'seeker/reviews',
        action:     'destroy',
        job_id:     '12',
        id:         '99'
      )
    end
  end
end
