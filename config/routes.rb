Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports
  resources :dispatches

  resources :users, only: [] do
    get 'home'
  end

  root 'pages#home'
end
