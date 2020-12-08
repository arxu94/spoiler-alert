class Api::V1::FoodsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    p '----'
    p food_params[:purchase_date]
    food_params[:purchase_date] = Date.parse(food_params[:purchase_date])
    @food = Food.new(food_params)
    p @food.errors
    p @food.errors
    p @food.errors
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
      ## add method to order by food expiring food
      @foods = Food.all.order(expire_date: :asc)
    end
    render json: @foods
  end

  ## this method will get all the tags that we have hardcoded
  ## use .unique after .all if the tags are duplicated after being added to other foods
  def tags
    @tags = ActsAsTaggableOn::Tag.all
    render json: @tags
  end

  # this method will find most tagged categories and give suggestions
  def tips
    @tag = ActsAsTaggableOn::Tag.most_used(1)
    if @tag == "Meat and Fish"
      message = "You have a lot of meat and fish, make sure you eat some veggies!"
    elsif @tag == "Dairy"
      message = "Your fridge is % dairy products, you sure do love your cheeses!"
    elsif @tag == "Fruits and Veggies"
      message = "You have a lot of fruits and veggies, keep it up!"
    elsif @tag == "Condiments"
      message = "You sure have a lot of sauces, make sure you put them to good use!"
    elsif @tag == "Eggs"
      message = "You have a lot of fruits and veggies, keep it up!"
    end
    @response = { most_used: @tag, message: message }
    render json: @response
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    head :no_content
  end

  private

  def render_error
    render json: { error: @food.errors.full_messages }
  end

# add tag list for categories
  def food_params
    params.require(:food).permit(:user_id, :name, :status, :shelf_life, :photo, :purchase_date, :expire_date, :tag_list)
  end
end
