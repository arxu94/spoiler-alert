class Api::V1::RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

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

  ### method to see all the recipes saved
  def my_recipes
    @recipes = Recipe.where(user_id: params[:id])
  end

  ### method to show one singular recipe when user clicks into it based on recipe id
  def show
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
    params.require(:recipe).permit(:user_id, :title, :ingredient, :instructions)
  end

  def render_error
    render json: { error: @recipe.errors.full_messages }
  end
end
