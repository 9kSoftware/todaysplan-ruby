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
    # +client+:: the authenticated client
    # +id+:: the athlete id
    # +options+:: has of options
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
  end
end
