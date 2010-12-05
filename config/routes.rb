Announcer::Application.routes.draw do
  match '/' => 'rooms#index'
  resources :people
  resources :rooms do
      resources :events
  end

  match '/:controller(/:action(/:id))'
end
