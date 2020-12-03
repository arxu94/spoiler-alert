class Api::V1::FoodsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

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
    params.require(:food).permit(:user_id, :name, :status, :shelf_life, :photo, :purchase_date, :tag_list)
  end
end
