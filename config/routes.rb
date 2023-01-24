Rails.application.routes.draw do
  use_doorkeeper

  root to: 'questions#index'

  concern :voteable do
    member do
      patch :like
      patch :dislike
      patch :reset_vote
    end
  end

  concern :commenteable do
    member do
      patch :add_comment
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks'
  }

  resources :rewards, only: :index

  resources :questions, only: %i[new create update show index destroy], concerns: [:voteable, :commenteable], shallow: true do
    delete :delete_file_attachment, on: :member

    resources :answers, only: %i[create update show destroy], concerns: [:voteable, :commenteable] do
      post :mark_answer_as_best, on: :member
    end
  end

  resources :confirmed_emails, only: %i[new create] do
    collection do
      get :confirm
    end
  end

  mount ActionCable.server => '/cable'
end
