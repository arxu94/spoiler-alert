class Api::V1::FoodsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    p '----'
    p food_params[:purchase_date]
    food_params[:purchase_date] = Date.parse(food_params[:purchase_date])
    if params[:expire_date].present?
      food_params[:expire_date] = Date.parse(food_params[:expire_date])
    end
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
      # @foods = Food.where(user_id: params[:id])
    @foods = Food.where(user_id: User.find(params[:user_id]))
      @foods = Food.all.order(expire_date: :asc)
    # if params[:query].present?
    #   @foods = @foods.where("name ILIKE ?", "%#{params[:query]}%")
      render json: @foods
    # else
      ## add method to order by food expiring food
      # render json: @foods
  end

  ## this method will get all the tags that we have hardcoded
  ## use .unique after .all if the tags are duplicated after being added to other foods
  def tags
    @tags = ActsAsTaggableOn::Tag.all
    render json: @tags
  end

  # this method will find most tagged categories and give suggestions
  def tips
    #pass in user's id
    @user_id = params[:user_id]
    #find all foods created by this user (how many tags in total)
    total = Food.where(user_id: @user_id).count
    @user = User.find(@user_id)
    # find specific tag total (for ex how many veggies)
    tag_hashes = @user.foods.tag_counts
    sorted_tag_hashes = tag_hashes.sort_by { |tag| -tag.taggings_count }
    most_popular_tag = sorted_tag_hashes[0]
    top = most_popular_tag.taggings_count
    percentage = ((top.to_f / total.to_f)*100).round(1)
# access the name of the tag that is most used, not the entire object of the tag
    @tag = most_popular_tag.name
    if @tag == "Meat"
      @message = "Your fridge is #{percentage}% meat, make sure you eat some veggies!"
    elsif @tag == "Seafood"
      @message = "Your fridge is #{percentage}% seafood, don't forget about veggies!"
    elsif @tag == "Dairy"
      @message = "Your fridge is #{percentage}% dairy products, you sure do love your cheeses!"
    elsif @tag == "Veggies"
      @message = "Your fridge is #{percentage}% veggies, keep it up!"
    elsif @tag == "Fruits"
      @message = "Your fridge is #{percentage}% fruits, be careful with sugar!"
    elsif @tag == "Condiments"
      @message = "You sure have a lot of sauces (#{percentage}% of your fridge!), make sure you put them to good use!"
    elsif @tag == "Eggs"
      @message = "Your fridge is #{percentage}% eggs, keep it up!"
    end

    @response = { most_used: @tag, message: @message, sorted: sorted_tag_hashes }
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
