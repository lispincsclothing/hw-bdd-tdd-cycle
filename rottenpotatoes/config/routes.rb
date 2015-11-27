Rottenpotatoes::Application.routes.draw do
  # map '/' to be a redirect to '/movies'
  root :to => 'movies#index'

  resources :movies do
      member do
        # Don't need as clause as default is to assign prefix as same name
        # get "/similar" => "movies#similar", :as => :similar
        get "/similar" => "movies#similar"
      end 
  end
end
