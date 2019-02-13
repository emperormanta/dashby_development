Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  devise_for :users

  get "/download_target_template", to: "master_target#download_template"
  post "/upload_csv_proposal", to: "master_target#upload"

   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
