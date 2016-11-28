Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  resources :questions do
    resources :votes, shallow_prefix: "question", type: 'Question', shallow: true, only: [] do
      member do
        post :upvote
        post :downvote
        delete :resetvote
      end
    end
    resources :answers, shallow: true do
      get :accept, on: :member
      resources :votes, shallow_prefix: "answer", type: 'Answer', only: [] do
        member do
          post :upvote
          post :downvote
          delete :resetvote
        end
      end
    end
  end

  resources :attachments, only: [:destroy]
end
