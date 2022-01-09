Rails.application.routes.draw do
  resources :calamities do
    resources :attendees
  end
  resources :teams do
    resources :team_members
  end
  resources :events
  devise_for :users
  root to: 'calamities#index'
end
