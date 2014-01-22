Smalljobs::Application.routes.draw do

  namespace :broker do
    resources :providers
  end

  devise_for :admins

  devise_for :seekers, controllers: {
    registrations:      'registrations',
    confirmations:      'confirmations',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  devise_for :providers, controllers: {
    registrations: 'registrations',
    confirmations: 'confirmations'
  }

  devise_for :brokers, controllers: {
    registrations: 'registrations',
    confirmations: 'confirmations'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :broker do
    resource :dashboard, only: :show
    resources :providers
    resources :seekers
  end

  namespace :provider do
    resource :dashboard, only: :show
  end

  namespace :seeker do
    resource :dashboard, only: :show
  end

  get 'sign_in',          to: 'pages#sign_in'
  get 'about_us',         to: 'pages#about_us'
  get 'privacy_policy',   to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service'

  root 'pages#home'
end
