Rails.application.routes.draw do
  # get "/books", to: "books#index"

  resources :books, only: [:index, :create]
end
