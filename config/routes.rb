Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  resources :questions do
    get :upvote, on: :member
    get :downvote, on: :member
    resources :answers, shallow: true do
      get :accept, on: :member
      get :upvote, on: :member
      get :downvote, on: :member
    end
  end
  get '/attachments/:id', to: 'attachments#destroy', as: 'attachment'
end
