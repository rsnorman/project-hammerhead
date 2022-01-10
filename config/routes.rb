Rails.application.routes.draw do
  resources :calamities do
    resources :attendees
    resources :email_responses, only: %i[ index show destroy ]
  end
  resources :teams do
    resources :team_members
  end
  resources :email_responses, only: %i[ create ]
  resources :events
  resources :commands
  devise_for :users
  root to: 'calamities#index'
end
