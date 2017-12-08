Rails.application.routes.draw do
  resources :cities
  resources :tags
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'pages/index'

  root 'pages#index'

  devise_for :users, path: 'auth', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout',
    edit: 'account'
  }
end
