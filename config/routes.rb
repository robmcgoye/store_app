Rails.application.routes.draw do
  root 'pages#home'
  get 'about_us', to: 'pages#about'
  resources :pages, only: [:edit, :update]
  resources :contacts, only: [:new, :create]
  resources :products
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  post "add_to_cart/:id", to: "cart#add_to_cart", as: "add_to_cart"
  patch "update_cart_quantity", to: "cart#update_quantity"
  delete "remove_from_cart/:id", to: "cart#remove_from_cart", as: "remove_from_cart"
  delete "remove_all_from_cart", to: "cart#remove_all_from_cart"
  resources :cart, only: [:index]
  get "checkout", to: "checkout#index"
  patch "checkout/address/:id", to: "checkout#update", as: "checkout_address_edit"
  post "checkout/address", to: "checkout#create", as: "checkout_address"
  get "success", to: "checkout#success"
  get "cancel", to: "checkout#cancel"
end
