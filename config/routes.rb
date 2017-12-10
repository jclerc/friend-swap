Rails.application.routes.draw do
  resources :friends
  resources :cities
  resources :tags

  post 'pages/search'
  get 'pages/search' => redirect('/')

  root 'pages#index'

  devise_for :users, path: 'auth', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout',
    edit: 'account'
  }
end
