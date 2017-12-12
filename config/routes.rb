Rails.application.routes.draw do
  root 'pages#index'

  resources :friends, except: %i[destroy]

  get 'search/(:city_name).(:city)/(:tag_name).(:tag)' => 'pages#search', as: 'search_get'
  get 'search' => redirect('/')
  post 'search' => 'pages#search', as: 'search_post'

  get 'exchanges' => 'exchanges#index', as: 'exchanges'
  get 'exchanges/new/(:friend_id).(:other_id)' => 'exchanges#new', as: 'exchanges_new'
  post 'exchanges/create' => 'exchanges#create', as: 'exchanges_create'
  get 'exchanges/finish/(:id)' => 'exchanges#get_finish', as: 'exchanges_get_finish'
  post 'exchanges/finish/(:id)' => 'exchanges#post_finish', as: 'exchanges_post_finish'
  get 'exchanges/rate/(:id)' => 'exchanges#get_rate', as: 'exchanges_get_rate'
  post 'exchanges/rate/(:id)' => 'exchanges#post_rate', as: 'exchanges_post_rate'

  devise_for :users, path: 'auth', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout',
    edit: 'account'
  }
end
