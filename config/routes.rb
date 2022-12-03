Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[new create update show index destroy] do
    resources :answers, only: %i[create update show destroy] do
      post :mark_answer_as_best, on: :member
    end
  end
end
