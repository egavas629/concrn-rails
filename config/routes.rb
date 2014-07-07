Streetmom::Application.routes.draw do
  devise_for :users

  resources :reports, except: %w(edit) do
    collection do
      get 'active'
      get 'history'
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
    member do
      post 'start', to: 'shifts#start', :as => :start_shift
      post  'end',  to: 'shifts#end',   :as => :end_shift
    end
  end
  resources :dispatches, only: %w(create update)
  resources :logs,       only: %w(create update)
  resources :reporters,  only: %w(show)
  resources :sms,        only: %w(create)

  root 'pages#home'
end
