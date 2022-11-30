Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[new create update show index destroy] do
    resources :answers, only: %i[create show destroy]
  end
end
