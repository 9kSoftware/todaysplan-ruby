module TodaysPlan
  # Uses the TodaysPlan API for workouts and athlete information

  class  Activity
    
    attr_reader :id
    attr_reader :athlete_id
    attr_reader :name
    attr_reader :state
    attr_reader :ts
    attr_reader :type
    attr_reader :completed_time
    attr_reader :planned_time
    attr_reader :description
    attr_reader :completed_tscorepwr
    attr_reader :planned_tscorepwr
    
    def initialize(fields)
      @id = fields['id'].to_i
      @athlete_id = fields['user']['id'].to_i
      @name = fields['name']
      @state = fields['state']
      @ts = Time.at(fields['ts'].to_i/1000).to_i
      @type = fields['type']
      @completed_time = fields["training"]
      @planned_time = fields.has_key?('scheduled') ? fields['scheduled']["durationSecs"] : nil
      @description = fields.has_key?('scheduled')? fields['scheduled']["preDescr"] : nil
      @completed_tscorepwr = fields["tscorepwr"]
      @planned_tscorepwr = fields.has_key?('scheduled')? fields['scheduled']["tscorepwr"] : nil
    end
    
    
    # Find all coaches athletes workouts
    # +payload+:: they payload to send to in json format
    # +offset+:: record count to start out
    # +total+:: number of records to return
    # +client+:: the authenticated client
    # payload example: 
    #    {
    #  "criteria": {
    #    "fromTs": 1451566800000,
    #    "toTs": 1496239200000,
    #    "isNull": [
    #      "fileId"
    #    ],
    #    "excludeWorkouts": [
    #      "rest"
    #    ]
    #  },
    #  "fields": [
    #    "scheduled.name",
    #    "scheduled.day",
    #    "workout",
    #     “state”, 
    #     “reason”
    #  ],
    #  "opts": 1
    #}
    def self.all(payload,offset = 0, total = 100, client: nil)
      Connector.new("/users/activities/search/#{offset}/#{total}/", client).
        post(payload)['result']['results'].map do |data|
        new(data)
      end
    end
      
  end
end
