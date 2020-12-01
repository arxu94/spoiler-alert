class Api::V1::FoodsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

require 'open-uri'

  def create
    @food = Food.new(food_params)
    if @food.save
      render json: { food: @food, status: :success }
    else
      render_error
    end
  end

  def index
    if params[:query].present?
      @food = Food.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @foods = Food.all
    end
    render json: @foods
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    head :no_content
  end

  ### method to mirror the recipes, same input for the route, make a request to the API spoonacular, wx request makes a get request to this route
  def mirror_spoonacular
  @results = params[:search]

  # interpolate the food name into the url link (don't forget the + sign in front)
  # hardcoded:
  url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=+flour,+sugar&number=10&apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"
  # interpolation:
  # url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=#{@results}&number=5&apiKey=8a69fc25f1ca4ccfa484d58fee68b86a"

  response = open(url).read
  @recipes = JSON.parse(response)
  # return the result of the spoonacular API
  render json: {result: @recipes}
  end

  private

  def render_error
    render json: { error: @food.errors.full_messages }
  end

  def food_params
    params.require(:food).permit(:user_id, :name, :status, :shelf_life, :photo, :purchase_date)
  end
end
