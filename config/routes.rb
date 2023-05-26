Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "movies#index"
  resources :movies do 
    resources :reviews
    collection { post :import }
  end

  resources :reviews do
    collection { post :import }
  end
end
