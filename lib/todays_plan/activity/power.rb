module TodaysPlan
  class Activity
    class Power
      
      
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
      
      def initialize(fields)
        @min_watts = fields['minWatts']
        @avg_watts = fields['avgWatts']
        @max_watts = fields['maxWatts']
        @threshold_watts =  fields['thresholdWatts']
        @sec_in_zone = fields["secsInZonePwr"]
        @tscorepwr = fields['tscorepwr']
        @intensity_factor = fields['iff']
        @kj = fields['kj']
        @wkg = fields['wkg']
        @np = fields['np']
        @ef = fields['ef']
        @vi = fields['vi']
        @vo2max = fields['vo2max']
      end
      
      
      def self.find(id, activity = 'workouts',client=nil)
        new(Connector.new("/plans/#{activity}/fragment/power/#{id}", client).get())

      end
    end
  end
 
end