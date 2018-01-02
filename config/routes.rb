Rails.application.routes.draw do

  # Ch8 Basic Login
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  get  '/signup',  to: 'users#new'


  # The member method arranges for the routes to respond to URLs containing
  # the user id.
  #
  # URLs for following: /users/1/following
  #      for followers: /users/1/followers
  #
  # HTTP request	  URL	                Action Named   route
  # GET	            /users/1/following	following	     following_user_path(1)
  # GET	            /users/1/followers	followers	     followers_user_path(1)
  resources :users do
    member do
      get :following, :followers
    end
  end

  # # The other possibility, collection, works without the id.
  # # The example below would respond to the URL /users/tigers
  # resources :users do
  #   collection do
  #     get :tigers
  #   end
  # end

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
