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
      @foods = Food.all
    end
    render json: @foods
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

  def food_params
    params.require(:food).permit(:user_id, :name, :status, :shelf_life, :photo, :purchase_date)
  end
end
