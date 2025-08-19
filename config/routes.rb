Rails.application.routes.draw do

  root "items#index"
  resources :items, only: [:index, :new, :create, :show]
  devise_for :users

end