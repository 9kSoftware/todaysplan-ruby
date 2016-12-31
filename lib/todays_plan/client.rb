module TodaysPlan
  class Client

    attr_reader :token

    def initialize(username,password)
      RestClient.log=TodaysPlan.logger
      @token = authenticate(username,password)
    end
    
    
    def logout
      url = TodaysPlan.endpoint+"/auth/logout"
      response= RestClient.get(url, {:Authorization => "Bearer #{token}"})
      response.body
    end
    
    private 
    def authenticate(username,password)
      payload= {'username'=>username,"password"=>password, "token"=> true}
      url = TodaysPlan.endpoint+"/auth/login"
      response= RestClient.post(url, payload.to_json,{content_type: :json, accept: :json} )
      body = JSON.parse(response.body)
      body['token']
    end
  end
end
