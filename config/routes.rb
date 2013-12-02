Smalljobs::Application.routes.draw do

  devise_for :admins

  devise_for :job_seekers, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_for :job_providers
  devise_for :job_brokers

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'job_brokers/dashboard',   to: 'broker_dashboard#index'
  get 'job_providers/dashboard', to: 'provider_dashboard#index'
  get 'job_seekers/dashboard',   to: 'seeker_dashboard#index'

  get 'sign_in',          to: 'pages#sign_in'
  get 'about_us',         to: 'pages#about_us'
  get 'privacy_policy',   to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service'

  root 'pages#home'
end
