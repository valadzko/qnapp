Rails.application.routes.draw do
  use_doorkeeper
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

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions
    end
  end

  resources :questions, concerns: [:votable,:commentable] do
    resources :answers, concerns: [:votable,:commentable], shallow: true do
      get :accept, on: :member
    end
  end

  resources :users, only: [] do
    collection do
      post 'require_email_for_auth'
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
