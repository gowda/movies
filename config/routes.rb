# frozen_string_literal: true

Rails.application.routes.draw do
  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get '/sessions/callback', to: 'sessions#create'

  resources :titles, only: :index

  namespace :admin, module: :admin do
    resources :datasets
  end

  root 'admin/datasets#index'
end
