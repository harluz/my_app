# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'
  # get '/log_in'  => 'static_pages#log_in'
  # get '/log_out' => 'static_pages#log_out'
  get '/about'   => 'static_pages#about'
  get '/profile' => 'static_pages#profile'
  # get '/my_list' => 'static_pages#my_list'
  # get '/suggest' => 'static_pages#suggest'
  # get '/seek'    => 'static_pages#seek'
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
  # get '/posts' => 'posts#new'
  # delete '/posts' => 'posts#destroy'
  resources :posts, only: %i[new create edit update destroy]
end
