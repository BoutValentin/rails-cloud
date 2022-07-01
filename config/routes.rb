Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Define the root of the application '/'
  root to: "home#index"

  resources :file_infos, only: [:create]
  get '/file', to: "file_infos#find"
  post '/file/regen_token', to: "file_infos#regen_token"
end
