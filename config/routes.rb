Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports do 
    collection do
      get 'active'
      get 'history'
    end
  end

  resources :responders, only: %w(index)
  resources :dispatches, only: %w(create)
  resources :sms

  root 'pages#home'
end
