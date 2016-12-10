Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  concern :votable do
    resources :votes, only: [] do
      collection do
        post :upvote
        post :downvote
        delete :resetvote
      end
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable,:commentable] do
    resources :answers, concerns: [:votable,:commentable], shallow: true do
      get :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
