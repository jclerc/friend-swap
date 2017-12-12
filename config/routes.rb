Rails.application.routes.draw do
  root 'pages#index'

  resources :friends, except: %i[destroy]

  get 'search/(:city_name).(:city)/(:tag_name).(:tag)' => 'pages#search', as: 'search_get'
  get 'search' => redirect('/')
  post 'search' => 'pages#search', as: 'search_post'

  get 'exchanges' => 'exchanges#index', as: 'exchanges'
  get 'exchanges/new/(:friend_id).(:other_id)' => 'exchanges#new', as: 'exchanges_new'
  get 'exchanges/finish/(:id)' => 'exchanges#finish', as: 'exchanges_finish'

  devise_for :users, path: 'auth', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout',
    edit: 'account'
  }
end
