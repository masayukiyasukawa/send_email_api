class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      attachments = user_params[:attachments]
      up_load = {}
      if attachments != nil
        up_load[:attachments] = attachments.read
        up_load[:attachments_type] = attachments.content_type
        up_load[:attachments_name] = attachments.original_filename
      end
      
      encode = Base64.strict_encode64(up_load[:attachments])
      data = {
        "dest": @user.dest,
        "subject": @user.subject,
        "body": @user.body,
        "attachments": 
        [
          [
            up_load[:attachments_name],
            "data:#{up_load[:attachments_type]};base64,#{encode}"
          ]
        ]
      }.to_json

      uri = @user.parse_uri

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
    
      req = Net::HTTP::Post.new(uri.request_uri)
      req["X-API-KEY"] = 'wFRndCxe2ido3kcCvUQa8OFw0W5wfEf7UJRZ1Rfb'
      req.body = data
      res = http.request(req)
      render json: res
    else
      render :action => "new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:dest, :subject, :body, :attachments)
    end
end
