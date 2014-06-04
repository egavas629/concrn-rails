Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports do
    collection do
      get 'active'
      get 'history'
      get 'deleted'
    end

    member do
      post 'upload'
      get 'download' => 'reports#download', :as => :download
    end
  end

  resources :reporter, only: %w(show)

  resources :contacts

  resources :logs

  resources :responders, except: %w(edit) do
    collection do
      get 'by_phone'
    end
  end

  resources :dispatches, only: %w(create)
  resources :sms

  root 'pages#home'
end
