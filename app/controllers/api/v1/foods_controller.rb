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
    p @food.errors
    p @food.errors
    p @food.errors
    checking_res = content_check(@food.name)
    p checking_res
    p checking_res
    p checking_res
    p "testing"
    p checking_res
    p checking_res
    if checking_res == 0
      p @food.errors
      p @food.errors
      p @food.errors
      if @food.save
        render json: { food: @food, status: :success }
      else
        render_error
      end
    else
     render json: {error: "content not ok"}
    end
  end

  def index
      # @foods = Food.where(user_id: params[:id])
    @foods = Food.where(user_id: User.find(params[:user_id])).order(expire_date: :asc)
      # @foods = @foods.all.order(expire_date: :asc)
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

    ####################################################
    def tips
    @user = User.find(params[:user_id])

    #find all foods created by this user (how many tags in total)
    total = Food.where(user_id: @user.id).count
    # find specific tag total (for ex how many veggies)

    if total > 0
      tag_hashes = @user.foods.tag_counts
      sorted_tag_hashes = tag_hashes.sort_by { |tag| -tag.count }
      most_popular_tag = sorted_tag_hashes[0]
      top = most_popular_tag.count
      percentage = ((top.to_f / total.to_f)*100).round(1)
  # access the name of the tag that is most used, not the entire object of the tag
        @tag = most_popular_tag.name
        if @tag == "Meat"
          @message = "Your fridge is mostly meat (#{percentage}% of your fridge), make sure you eat some veggies."
        elsif @tag == "Seafood"
          @message = "Your fridge is mostly seafood (#{percentage}% of your fridge), don't forget about veggies! And don't forget to just keep swimming just keep swimming..."
        elsif @tag == "Dairy"
          @message = "Your fridge is mostly dairy products (#{percentage}% of your fridge), sweet baby cheesus, you sure do love your cheeses."
        elsif @tag == "Veggies"
          @message = "Your fridge is mostly veggies (#{percentage}% of your fridge), keep it up."
        elsif @tag == "Fruits"
          @message = "Your fridge is mostly fruit (#{percentage}% of your fridge), be careful with your sugar intake."
        elsif @tag == "Condiments"
          @message = "You sure have a lot of sauces (#{percentage}% of your fridge!), make sure you put them to good use. Pregooooo."
        elsif @tag == "Eggs"
          @message = "Your fridge is mostly eggs (#{percentage}% of your fridge), that's eggcellent... Did the chicken or egg come first though?"
        elsif @tag == "Others"
          @message = "Your fridge is #{percentage}% full of surprises! Don't forget to eat your veggies."
        end
        render json: { most_used: @tag, message: @message, sorted: sorted_tag_hashes }
    else
      @message = "Nothing in your fridge yet, let's add some food."
      render json: { most_used: @tag, message: @message, sorted: sorted_tag_hashes }
    end
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
