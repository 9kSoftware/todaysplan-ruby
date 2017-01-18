module TodaysPlan
  # Uses the TodaysPlan API for workouts and athlete information

  class User
    
    attr_reader :id
    attr_reader :name
    attr_reader :first_name
    attr_reader :last_name
    attr_reader :timezone
    attr_reader :coach
    attr_reader :email
    attr_reader :dob
    attr_reader :country
    

    def initialize(fields)
      @id = fields['id'].to_i
      @name = fields['_name']
      @first_name = fields['firstname']
      @last_name = fields['lastname']
      @timezone =fields['timezone']
      @coach =  fields['coach']["id"].to_i if fields.has_key?("coach")
      @email = fields['email']
      @dob =  Time.at(fields['dob'].to_i/1000)
      @country = fields['country']
    end
      
    # Find a single athlete 
    # +id+:: the athlete id
    # returns User
    def self.find(id)      
      all().find{|a| a.id==id}
    end
    
    # Find all the coaches athletes 
    # +client+:: the authenticated client
    # returns [User]
    def self.all(client = nil)
      Connector.new('/users/delegates/users', client).get.map do |data|
        new(data)
      end
    end
    
    
    # Register a new user
    # This is an unauthenticated request.
    # options:
    #   email - email address of new user
    #   firstname - first name of new user
    #   lastname - last name of new user
    #   password - password of new user
    # returns User
    def self.register(options)
      #preregister
      response = RestClient.get("#{TodaysPlan.endpoint}/auth/preregister")

      # register/create the user
      payload = {email: options[:email], firstname: options[:firstname],
        lastname: options[:lastname], password: options[:password]}
      response = RestClient.post("#{TodaysPlan.endpoint}/auth/register",payload.to_json,
        { content_type: :json})
      response.body
      new(JSON.parse(response.body))
    end
    
    # Invite delegates
    # This is an authenticated request of the new user to invite the delegates (coach)
    # options 
    #   relationship - relationship of delegate, i.e coach
    #   state - state of invite. i.e pending_coach
    #   email - delegates email in todaysplan
    # returns Hash of the invite
    def self.invite(options, client = nil)
      # new user invites coach
      invite={"email"=>options[:email],"state"=> options[:state], 
        "relationship"=> options[:relationship]}.to_json
      Connector.new('/users/delegates/invite', client).post(invite)
    end
    
    # Accept pending invitations
    # This is an authenticated request of the delegate (coach) to accept invites
    # from the new user.
    # queries for pending invitations and accept them.
    # options 
    #   id - id of the invite from #invite 
    #   state - state of invite. i.e pending_coach
    # returns [User]
    def self.accept_invites(options, client = nil) 
      Connector.new('/users/delegates/search/0/100', client).
        post({ "state"=> options[:state]}.to_json)["results"].map do |data|

        # accept found invite
        new(Connector.new("/users/delegates/invite/accept/#{data["id"]}").get()["client"])
        
      end
    end
  end
end
