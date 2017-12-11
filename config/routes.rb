Rails.application.routes.draw do
  resources :friends, except: %i[index destroy]
  get 'friends' => redirect('/')
  resources :cities
  resources :tags

  get 'search/(:city_name).(:city)/(:tag_name).(:tag)' => 'pages#search', as: 'search_get'
  get 'search' => redirect('/')
  post 'search' => 'pages#search', as: 'search_post'

  root 'pages#index'

  devise_for :users, path: 'auth', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout',
    edit: 'account'
  }
end
