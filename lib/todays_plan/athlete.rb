module TodaysPlan
  # Uses the TodaysPlan API for workouts and athlete information

  class Athlete
    
    attr_reader :id
    attr_reader :name
    attr_reader :first_name
    attr_reader :last_name
    attr_reader :timezone
    attr_reader :coach
    attr_reader :email
    attr_reader :dob
    

    def initialize(fields)
      @id = fields['id'].to_i
      @name = fields['_name']
      @first_name = fields['firstname']
      @last_name = fields['lastname']
      @timezone = fields['timezone']
      @coach =  fields['coach']["id"].to_i if fields.has_key?("coach")
      @email = fields['email']
      @dob =  Time.at(fields['dob'].to_i/1000)
    end
      
    # Find a single athlete 
    # +id+:: the athlete id
    def self.find(id)      
      all().find{|a| a.id==id}
    end
    
    # Find all the coaches athletes 
    # +client+:: the authenticated client
    def self.all(client = nil)
      Connector.new('/users/delegates/users', client).get.map do |data|
        new(data)
      end
    end
    
    # Create new Athlete\
    # options 
    #   user_email - email address of new user
    #   firstname - first name of new user
    #   lastname - last name of new user
    #   password - password of new user
    #   coach_email - coach email in todaysplan
    def self.create(options, client = nil)

      #preregister
      response = RestClient.get("#{TodaysPlan.endpoint}/auth/preregister")

      # register the user
      payload = {email: options[:user_email], firstname: options[:first_name],
        lastname: options[:last_name], password: options[:password]}
      response = RestClient.post("#{TodaysPlan.endpoint}/auth/register",payload.to_json,
        { content_type: :json})
      response.body
      athlete = new(JSON.parse(response.body))
      # user invites coach
      user_client = TodaysPlan::Client.new(options[:user_email], options[:password])
      invite={"email"=>options[:coach_email],"state"=> "pending_coach", 
        "relationship"=> "coach"}.to_json
      response = Connector.new('/users/delegates/invite', user_client).post(invite)
      
      # find invitation and accept
      Connector.new('/users/delegates/search/0/100', client).
        post({ "state"=> "pending_coach"}.to_json)["results"].each do |result|
        id = result["id"]
        Connector.new("/users/delegates/invite/accept/#{id}", client).get() 
        
      end
      athlete
    end
  end
end
