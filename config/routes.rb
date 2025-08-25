Rails.application.routes.draw do

  root "items#index"
  resources :items, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  devise_for :users

resources :items do
  resources :orders, only: [:index, :create]
  end
end