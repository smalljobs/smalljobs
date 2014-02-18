require 'main_subdomain'
require 'region_subdomain'

Smalljobs::Application.routes.draw do

  devise_for :admins

  devise_for :brokers, only: :confirmations, controllers: {
    confirmations: 'confirmations'
  }

  devise_for :providers, only: :confirmation, controllers: {
    confirmations: 'confirmations'
  }

  devise_for :seekers, only: :confirmation, controllers: {
    confirmations: 'confirmations'
  }

  get 'about_us',         to: 'pages#about_us'
  get 'privacy_policy',   to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service'
  get 'features',         to: 'pages#features'
  get 'join_us',          to: 'pages#join_us'

  constraints(RegionSubdomain) do
    devise_for :brokers, except: :confirmation, controllers: {
      registrations: 'registrations'
    }

    devise_for :providers, except: :confirmation, controllers: {
      registrations: 'registrations'
    }

    devise_for :seekers, except: :confirmation, controllers: {
      registrations:      'registrations'
    }

    get 'sign_in', to: 'pages#sign_in'

    namespace :broker do
      resource :dashboard, only: :show
      resources :providers
      resources :seekers
      resources :jobs
    end

    namespace :provider do
      resource :dashboard, only: :show
      resources :jobs
    end

    namespace :seeker do
      resource :dashboard, only: :show
    end

    resources :jobs, only: :show

    get '/' => 'regions#show'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'regions#index'
end
