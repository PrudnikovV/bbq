Rails.application.routes.draw do
  devise_for :users
  root "events#index"
  get 'destroy_event' => 'events#destroy'

  resources :events
  resources :users, only: [:show, :edit, :update]
end
