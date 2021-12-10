# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin, module: :admin do
    resources :datasets
  end

  root 'admin/datasets#index'
end
