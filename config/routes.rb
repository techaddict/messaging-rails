MessagingRails::Application.routes.draw do
  get "message/inbox"
  get "message/sent"
  get "message/new"
  put "message/new"
  post "message/new"
  post "message" => 'message#create'
  get "message/:id" => 'message#show'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end