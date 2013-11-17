Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports
  resources :dispatches, only: %w(create)
  resources :sms

  root 'pages#home'
end
