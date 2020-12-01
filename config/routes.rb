Rails.application.routes.draw do
  # removed root home page as there is none in wechat MP
  # root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :foods, only: [:index, :create, :destroy]
    end
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :recipes, only: [:create, :show, :destroy]
      get "/users/:id/recipes", to: "recipes#my_recipes", as: 'my_recipes'
      ### add scraper get here later###
    end
  end

  post '/login', to: 'login#login'
end
