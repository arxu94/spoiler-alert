class LoginController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:login]

  URL = "https://api.weixin.qq.com/sns/jscode2session".freeze

  def wechat_user
    wechat_params = {
      appId: ENV["WECHAT_APP_ID"],
      secret: ENV["WECHAT_APP_SECRET"],
      js_code: params[:code],
      grant_type: "authorization_code"
    }

    @wechat_response ||= RestClient.get(URL, params: wechat_params)
    @wechat_user ||= JSON.parse(@wechat_response.body)
  end

  def login
    @user = User.find_or_create_by(open_id: wechat_user.fetch("openid"))
    tip = tips
    render json: {
      user: @user,
      tips: tip
    }
  end

  def tips
    #pass in user's id
    @user_id = @user.id
    #find all foods created by this user (how many tags in total)
    total = Food.where(user_id: @user_id).count
    # find specific tag total (for ex how many veggies)
    tag_hashes = @user.foods.tag_counts
    sorted_tag_hashes = tag_hashes.sort_by { |tag| -tag.taggings_count }
    most_popular_tag = sorted_tag_hashes[0]
    top = most_popular_tag.taggings_count
    percentage = ((top.to_f / total.to_f)*100).round(1)
# access the name of the tag that is most used, not the entire object of the tag
    @tag = most_popular_tag.name
    if @tag == "Meat and Fish"
      @message = "Your fridge is #{percentage}% meat and fish, make sure you eat some veggies!"
    elsif @tag == "Dairy"
      @message = "Your fridge is #{percentage}% dairy products, you sure do love your cheeses!"
    elsif @tag == "Fruits and Veggies"
      @message = "Your fridge is #{percentage}% fruits and veggies, keep it up!"
    elsif @tag == "Condiments"
      @message = "You sure have a lot of sauces (#{percentage}% of your fridge!), make sure you put them to good use!"
    elsif @tag == "Eggs"
      @message = "Your fridge is #{percentage}% eggs, keep it up!"
    end

    @response = { most_used: @tag, message: @message, sorted: sorted_tag_hashes }
    end
end
