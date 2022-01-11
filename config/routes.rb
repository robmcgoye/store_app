Rails.application.routes.draw do
  root 'pages#home'
  get 'about_us', to: 'pages#about'
  resources :pages, only: [:edit, :update]
  resources :contacts, only: [:new, :create]
  resources :products
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
