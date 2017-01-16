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
      options={
        method: :get, 
        headers:{ accept: :json}
      }
      run(options)
    end
    
    # Internal: Run GET request.
    #
    # Returns the parsed JSON response body.
    def post(payload = {})
      options={method: :post, 
        payload: payload, 
        headers:{content_type: :json, accept: :json}
      }
      run(options)
    end
    
    private
    
    def run(options)
      @response = RestClient::Request.execute(
        method: options[:method],
        payload: options[:payload], url: @uri, 
        timeout: @timeout, 
        headers: options[:headers].merge({:Authorization => "Bearer #{@client.token}"})
      )
      if @response.body.nil? || @response.body.empty?
        raise TodaysPlan::ServerError.new(0, 'Server error', 'Try to connect later')
      end
      
      puts "#{@response.inspect}" if TodaysPlan.debug
      
      @body = JSON.parse(@response.body)
      case @response.code
      when 200..207
        @body
      else
        raise_error
      end
    end
    
    # Internal: Raise an error with the class depending on @response.
    #
    # Returns an Array with arguments.
    def raise_error
      klass = case @response.to_s
        when "RestClient::BadRequest" then TodaysPlan::BadRequestError
        when "RestClient::Unauthorized" then  TodaysPlan::UnauthorizedError
        when "RestClient::NotFound" then TodaysPlan::NotFoundError
        else
          TodaysPlan::ServerError
        end
      raise klass.new(body['code'], body['message'], body['resolve'])
    end
  end
end