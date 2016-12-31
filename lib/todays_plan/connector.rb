module TodaysPlan
  class Connector
    attr_reader :uri, :response, :body, :timeout, :client

    def initialize(path, client = nil)
      @client = client || Client.new(TodaysPlan.username, TodaysPlan.password)
      @uri = TodaysPlan.endpoint + path
      @timeout = TodaysPlan.timeout
    end
    
    # Internal: Run GET request.
    #
    # Returns the parsed JSON response body.
    def get()
      @response =  RestClient::Request.execute(method: :get, url: @uri, 
        timeout: @timeout, 
        headers: {:Authorization => "Bearer #{@client.token}",accept: :json} )
      puts "#{@response.body}" if TodaysPlan.debug
      @body = JSON.parse(@response.body)
    end
    
    # Internal: Run GET request.
    #
    # Returns the parsed JSON response body.
    def post(payload = {})
      @response =  RestClient::Request.execute(method: :post,
        payload: payload, url: @uri, 
        timeout: @timeout, 
        headers:{:Authorization => "Bearer #{@client.token}",
          content_type: :json,
          accept: :json})
      puts "#{@response.body}" if TodaysPlan.debug
      @body = JSON.parse(@response.body)
      @body
    end
    
    
  end
end