Rails.application.routes.draw do
  resources :tags
  resources :posts
  devise_for :users
  root 'posts#index'
  resources :posts do
    resources :comments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
