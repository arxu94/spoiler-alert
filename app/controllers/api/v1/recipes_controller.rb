class Api::V1::RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

require 'open-uri'

  ### method to save new recipe when user saves one they like
  def create
    @recipe = Recipe.new(recipe_params)
    # debugger
    if @recipe.save
      render json: { recipe: @recipe, status: :success }
    else
      render_error
    end
  end

  ### method to see all the recipes saved and search as well
  def my_recipes
    if params[:query].present?
      @my_recipes = Recipe.where(user_id: params[:id])
      # user_recipes = @my_recipes.where()
      # @my_recipes = user_recipes.select("title ILIKE ?", "%#{params[:query]}%")
      # @updated_res = @my_recipes
      @result = @my_recipes.where("title ILIKE ?", "%#{params[:query]}%")
      # Recipe.where(user_id: params["id"], title: params["title"])
      render json: { recipes: @result, status: :hellospoileralert }
    else
      @my_recipes = Recipe.where(user_id: params[:id])
      render json: { recipes: @my_recipes, status: :success }
    end
  end

  ### method to show one singular recipe when user clicks into it based on recipe id
  def show
    render json: @recipe
  end

  ### method to mirror the recipes, same input for the route, make a request to the API spoonacular, wx request makes a get request to this route
  def recipe_results
    # p "------------"
    # p params[:search]
    # @ingredients = params[:search].gsub(params[:search][-1],"")
    @ingredients = params[:search]
    # interpolate the food name into the url link (don't forget the + sign in front)
    # hardcoded:
    # url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=+flour,+sugar&number=5&apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"
    # ariel's key
    url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{@ingredients}&number=5&apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"

    #alex's key
    # url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{@ingredients}&number=5&apiKey=85aeca77d8134a13be3a459305815224"


    response = open(url).read
    @recipes = JSON.parse(response)

    # @recipes.map!{|r|
    #   r['instructions'] = r['instructions']
    # }
    # return the result of the spoonacular API
    render json: { result: @recipes }
  end

# get detailed recipe based on id
  def recipe_details
    @recipe_id = params[:id]
    # hardcoded:
    # url = "https://api.spoonacular.com/recipes/120/information?apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"
    # interpolated

    #ariel's key
    url = "https://api.spoonacular.com/recipes/#{@recipe_id}/information?apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"

    #alex's key
    # url = "https://api.spoonacular.com/recipes/#{@recipe_id}/information?apiKey=85aeca77d8134a13be3a459305815224"

    response = open(url).read
    @recipe = JSON.parse(response)
    # return the result of the spoonacular API


    # render json: { result: @recipe }
  end

  ### method to delete one recipe based on recipe id
  def destroy
    @recipe.destroy
    head :no_content
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:user_id, :title, :instructions, :ingredient, :image, :cooking_time)
  end

  def render_error
    render json: { error: @recipe.errors.full_messages }
  end
end

