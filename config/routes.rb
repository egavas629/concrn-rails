Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports do
    collection do
      get 'active'
      get 'history'
      get 'deleted'
    end

    member do
      get 'download' => 'reports#download', :as => :download
    end
  end

  resources :responders, except: %w(edit) do
    collection do
      get 'by_phone'
      get 'deactivated'
    end
  end
  resources :dispatches, only: %w(create update)
  resources :logs
  resources :reporter,   only: %w(show)
  resources :sms

  root 'pages#home'
end
