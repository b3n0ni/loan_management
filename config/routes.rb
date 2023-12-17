Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'

  resources :loans do
    get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :loans do
      member do
        patch 'accept'
        post 'approve'
        post 'reject'
      end
    end
  end

  namespace :user do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :loans do
      member do
        post 'repay'
        post 'confirm'
        post 'reject'
      end
    end
  end

  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'
end
