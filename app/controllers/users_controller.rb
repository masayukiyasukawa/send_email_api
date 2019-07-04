class UsersController < ApplicationController
  require 'net/https'
  require 'uri'
  require 'json'
  require 'cgi'
  require 'base64'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      base_url = 'https://hlw9zpstkf.execute-api.ap-northeast-1.amazonaws.com/production/submit'
  
      uri = URI.parse(base_url)
      http = Net::HTTP.new(uri.host, uri.port)
    
      http.use_ssl = true
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/json"
      req["X-API-KEY"] = 'wFRndCxe2ido3kcCvUQa8OFw0W5wfEf7UJRZ1Rfb'

      image = Base64.encode64(@user.attachments)
      data = {
          "dest":@user.dest,
          "subject":@user.subject,
          "body":@user.body,
          "attachments":image
          # "attachments":@user.attachments
      }.to_json
    
      req.body = data
      res = http.request(req)
      render json: @user
    else
      render :action => "new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:dest, :subject, :body, :attachments)
    end
end
