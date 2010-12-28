Announcer::Application.routes.draw do
  namespace :backend do
    resources :events
    resources :conferences do
      resource :import, :controller => 'conference_import'
    end
  end

  match '/backend' => 'backend/conferences#index'

  match '/' => 'rooms#index'
  resources :people
  resources :rooms do
      resources :events
  end

  match '/:controller(/:action(/:id))'
end
