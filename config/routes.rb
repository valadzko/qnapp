Rails.application.routes.draw do
  devise_for :users
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

  resources :questions, conserns: [:votable] do
    resources :answers, conserns: [:votable], shallow: true do
      get :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
