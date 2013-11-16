Streetmom::Application.routes.draw do
  devise_for :users
  resources :reports
  root 'pages#home'

end
