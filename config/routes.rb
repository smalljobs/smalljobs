Smalljobs::Application.routes.draw do

  devise_for :admins

  devise_for :job_seekers
  devise_for :job_providers
  devise_for :job_brokers

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'pages#home'
end
