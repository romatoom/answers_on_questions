Rails.application.routes.draw do
  root to: 'questions#index'

  concern :voteable do
    member do
      patch :like
      patch :dislike
      patch :reset_vote
    end
  end

  devise_for :users

  resources :rewards, only: :index

  resources :questions, only: %i[new create update show index destroy], concerns: [:voteable], shallow: true do
    delete :delete_file_attachment, on: :member

    resources :answers, only: %i[create update show destroy], concerns: [:voteable] do
      post :mark_answer_as_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
