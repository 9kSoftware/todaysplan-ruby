module TodaysPlan
  class Activity
    class Summary
      
      
      attr_reader :min_watts
      attr_reader :avg_watts
      attr_reader :max_watts
      attr_reader :threshold_watts
      attr_reader :sec_in_zone
      attr_reader :tscorepwr
      attr_reader :intensity_factor
      attr_reader :kj
      attr_reader :wkg
      attr_reader :np
      attr_reader :ef
      attr_reader :vi
      attr_reader :vo2max
      attr_reader :min_bpm
      attr_reader :avg_bpm
      attr_reader :max_bpm
      attr_reader :threshold_bpm
      attr_reader :tscorehr
      attr_reader :intensity_factor
      attr_reader :calories
      attr_reader :min_alt
      attr_reader :avg_alt
      attr_reader :max_alt
      attr_reader :ascent
      attr_reader :descent
      attr_reader :avg_speed
      attr_reader :max_speed
      attr_reader :min_temp
      attr_reader :avg_temp
      attr_reader :max_temp
      attr_reader :avg_cadence
      attr_reader :max_cadence
      attr_reader :idle
      attr_reader :distance
      attr_reader :power_meter
      attr_reader :ts
       
      def initialize(fields)
        @min_watts = fields['minWatts']
        @avg_watts = fields['avgWatts']
        @max_watts = fields['maxWatts']
        @threshold_watts =  fields['thresholdWatts']
        @tscorepwr = fields['tscorepwr']
        @intensity_factor = fields['iff']
        @kj = fields['kj']
        @wkg = fields['wkg']
        @np = fields['np']
        @ef = fields['ef']
        @vi = fields['vi']
        @vo2max = fields['vo2max']
        @min_bpm = fields['minBpm']
        @avg_bpm = fields['avgBpm']
        @max_bpm = fields['maxBpm']
        @threshold_bpm =  fields['thresholdBpm']
        @tscorehr = fields['tscorehr']
        @calories = fields['calories']
        @min_alt = fields['minAlt']
        @avg_alt = fields['avgAlt']
        @max_alt = fields['maxAlt']
        @ascent = fields["ascent"]
        @descent = fields["descent"]
        @avg_speed = fields['avgSpeed']
        @max_speed = fields['maxSpeed']
        @avg_cadence = fields['avgCadence']
        @max_cadence = fields['maxCadence'] 
        @min_temp = fields['minTemp']
        @avg_temp = fields['avgTemp']
        @max_temp = fields['maxTemp']
        @idle = fields['idle']
        @distance = fields['distance']
        @ts = fields['ts']
        @power_meter = fields.has_key?('powermeter') ? fields['powermeter']["name"] : nil
      end
      
      
      def self.find(id, activity = 'workouts',client=nil)
        new(Connector.new("/plans/#{activity}/fragment/summary/#{id}", client).get())
      end
    end
  end
 
end