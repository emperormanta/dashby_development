Rails.application.routes.draw do
  devise_for :users
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  post "/me", to: "current_users#me"
  get "/download_target_template", to: "master_target#download_template"
  post "/upload_csv_target", to: "master_target#upload"

   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
