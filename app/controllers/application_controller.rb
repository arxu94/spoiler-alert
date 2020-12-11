class ApplicationController < ActionController::Base

  def token_request
      token_params = {
        appId: ENV['WECHAT_APP_ID'],
        secret: ENV['WECHAT_APP_SECRET'],
        grant_type: "client_credential"
      }
      @wechat_response ||= RestClient.get("https://api.weixin.qq.com/cgi-bin/token", params: token_params)
      @getToken ||= JSON.parse(@wechat_response.body)
  end

  def content_check(string1, string2 = '', string3 = '', string4 = '')
    getToken_res = token_request
    content_for_checking = string1 + string2 + string3 + string4
    p getToken_res
    p content_for_checking
    if getToken_res["access_token"].present?
      p "access ok"
      token = getToken_res.fetch("access_token")
      @msg_check_response ||= RestClient.post "https://api.weixin.qq.com/wxa/msg_sec_check?access_token=#{token}", {content: content_for_checking }.to_json
      @msg_check ||= JSON.parse(@msg_check_response.body)
      p @msg_check
    return @msg_check
    end
  end
end

