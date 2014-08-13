Streetmom::Application.routes.draw do

  resources :agencies

  devise_for :users, path_prefix: 'my'

  resources :reports, except: %w(edit) do
    collection do
      get 'active'
      get 'history'
    end

    member do
      post 'upload' => 'reports#update'
      get 'download' => 'reports#download', :as => :download
    end
  end

  resources :users, except: %w(destroy) do
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
