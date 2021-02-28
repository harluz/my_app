# frozen_string_literal: true

Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  get 'orders/edit'
  get 'orders/update'
  get 'orders/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'
  get '/about'   => 'static_pages#about'
  get '/profile' => 'static_pages#profile'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ログイン
  get '/login'   => 'sessions#new'
  post '/login'  => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  # ユーザー登録
  get '/signup'  => 'users#new'
  post '/signup' => 'users#create'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]

  # 投稿機能
  resources :posts, only: %i[new create edit update destroy]

  # 注文機能
  resources :orders, only: %i[new create edit update destroy]
end
