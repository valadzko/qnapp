Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  resources :questions do
    resources :answers, shallow: true do
      get :accept, on: :member
    end
  end
  get '/votes/:id/:type/upvote', to: 'votes#upvote', as: 'upvote'
  get '/votes/:id/:type/downvote', to: 'votes#downvote', as: 'downvote'
  get '/votes/:id/:type/resetvote', to: 'votes#resetvote', as: 'resetvote'

  get '/attachments/:id', to: 'attachments#destroy', as: 'attachment'
end
