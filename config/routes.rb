Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[new create update show index destroy] do
    delete :delete_file_attachment, on: :member

    resources :answers, only: %i[create update show destroy] do
      post :mark_answer_as_best, on: :member
    end
  end
end
