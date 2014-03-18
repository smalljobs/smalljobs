require 'main_subdomain'
require 'region_subdomain'

Smalljobs::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

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
  get 'rules_of_action',  to: 'pages#rules_of_action'

  constraints(RegionSubdomain) do
    devise_for :brokers, except: :confirmation, controllers: {
      registrations: 'registrations'
    }

    devise_for :providers, except: :confirmation, controllers: {
      registrations: 'registrations'
    }

    devise_for :seekers, except: :confirmation, controllers: {
      registrations: 'registrations'
    }

    get 'sign_in', to: 'pages#sign_in'

    namespace :broker do
      resource :dashboard, only: :show
      resource :organization, only: [:edit, :update]

      resources :providers
      resources :seekers

      resources :jobs do
        member do
          post 'activate'
        end

        resources :proposals, except: :show
        resources :applications, except: :show
        resources :allocations, except: :show
        resources :reviews, except: :show
      end
    end

    namespace :provider do
      resource :dashboard, only: :show

      resources :jobs do
        resources :allocations, only: [:index, :show]
        resources :reviews, except: :show
      end
    end

    namespace :seeker do
      resource :dashboard, only: :show

      resources :jobs, only: [:index, :show] do
        resources :proposals, only: [:index, :show]
        resources :applications, except: :show
        resources :allocations, only: [:index, :show]
        resources :reviews, except: :show
      end
    end

    resources :jobs, only: :show

    get '/' => 'regions#show'
  end

  root 'regions#index'
end
