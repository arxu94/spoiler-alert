Rails.application.routes.draw do
  # removed root home page as there is none in wechat MP
  # root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :foods, only: [:index, :create, :destroy]
      get "/taglist", to: "foods#tags"
      get "/tips/:user_id", to: "foods#tips"

      resources :recipes, only: [:create, :show, :destroy]

      # get "/users/:id/recipes", to: "recipes#my_recipes"
      get "/users/:id/recipes", to: "recipes#my_recipes", as: 'my_recipes'
      get "/find_recipes", to: "recipes#recipe_results"
      get "/recipe_details", to: "recipes#recipe_details"

    end
  end

  post '/login', to: 'login#login'
  # get "/tips/:user_id", to: "login#tips"
end
