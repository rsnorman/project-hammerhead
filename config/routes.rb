Rails.application.routes.draw do
  resources :calamities
  resources :events
  devise_for :users
  root to: 'calamities#index'
end
