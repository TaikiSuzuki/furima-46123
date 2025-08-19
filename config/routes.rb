Rails.application.routes.draw do

  root "items#index"
  resources :items, only: [:index, :new, :create, :show, :edit, :update]
  devise_for :users

end