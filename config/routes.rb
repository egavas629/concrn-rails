Streetmom::Application.routes.draw do
  resources :reports
  root 'reports#index'

end
