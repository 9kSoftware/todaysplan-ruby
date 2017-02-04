module TodaysPlan
  # Uses the TodaysPlan API for workouts and athlete information

  class  Activity
    
    attr_reader :id
    attr_reader :activity_id
    attr_reader :athlete_id
    attr_reader :name
    attr_reader :state
    attr_reader :ts
    attr_reader :type
    attr_reader :completed_time
    attr_reader :scheduled_time
    attr_reader :description
    attr_reader :tscorepwr
    attr_reader :scheduled_tscorepwr
    attr_reader :intensity_factor
    attr_reader :activity
    
    def initialize(fields)
      @id = fields['id'].to_i
      @activity_id = fields['activityId'].to_i
      @athlete_id = fields['user']['id'].to_i
      @name = fields['name']
      @state = fields['state']
      @ts = fields['ts'].to_i
      @type = fields['type']
      @completed_time = find_completed_time(fields)
      @scheduled_time = find_planned_time(fields)
      @description = fields.has_key?('scheduled')? fields['scheduled']["preDescr"] : nil
      @tscorepwr = find_completed_tscore(fields)
      @scheduled_tscorepwr = find_planned_tscore(fields)
      @intensity_factor = fields['iff']
      @activity = fields['activity']
    end
    
    # Find the activity
    # +id+:  the activity id
    # +activity+: the type of activity to view, workouts or files.  Defaults to workouts
    # +client+:: the authenticated client
    def self.find(id, activity="workouts", client = nil)
      fields = {"activityId"=>id}
      new(fields.merge(Connector.new("/plans/#{activity}/detailed/#{id}",client).get()))
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
    
    private
    
    def find_completed_tscore(fields)
      if fields.has_key?('tscorepwr') 
        fields["tscorepwr"]
      elsif fields.has_key?('targets') 
        fields['targets']["tscorepwr"]['completed'] if fields['targets']["tscorepwr"]
      else
        nil
      end
    end
    
    def find_planned_tscore(fields)
      if fields.has_key?('scheduled') 
        fields['scheduled']["tscorepwr"] 
      elsif fields.has_key?('targets') 
        fields['targets']["tscorepwr"]['scheduled'] if fields['targets']["tscorepwr"]
      else 
        nil
      end
    end
    
    def find_planned_time(fields)
      if fields.has_key?('scheduled') 
        fields['scheduled']["durationSecs"] 
      elsif fields.has_key?('targets') 
        fields['targets']["duration"]['scheduled']
      else 
        nil
      end
    end
    
    def find_completed_time(fields)
      if fields.has_key?('training') 
        fields["training"]
      elsif fields.has_key?('targets') 
        fields['targets']["duration"]['completed']
      else
        nil
      end
    end
      
  end
end
