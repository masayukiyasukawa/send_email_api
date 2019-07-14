class User < ApplicationRecord

  def parse_uri
    base_url = 'https://hlw9zpstkf.execute-api.ap-northeast-1.amazonaws.com/production/submit'
    uri = URI.parse(base_url)
  end

end
