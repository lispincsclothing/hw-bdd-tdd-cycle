Rottenpotatoes::Application.routes.draw do
  # order matters in terms of routing - bg error in terms of putting root before resources
  #otherwise rspec test fails
  #TODO: Ask why
  resources :movies do
      member do
        # Don't need as clause as default is to assign prefix as same name
        # get "/similar" => "movies#similar", :as => :similar
        get "/similar" => "movies#similar"
      end
  end
  # map '/' to be a redirect to '/movies'
  root :to => 'movies#index'
end
