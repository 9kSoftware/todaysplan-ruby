module TodaysPlan
  class Activity
    class Heartrate
      
      attr_reader :min_bpm
      attr_reader :avg_bpm
      attr_reader :max_bpm
      attr_reader :threshold_bpm
      attr_reader :sec_in_zone
      attr_reader :tscorehr
      attr_reader :intensity_factor
      attr_reader :calories

      
      def initialize(fields)
        @min_bpm = fields['minBpm']
        @avg_bpm = fields['avgBpm']
        @max_bpm = fields['maxBpm']
        @threshold_bpm =  fields['thresholdBpm']
        @sec_in_zone = fields["secsInZoneBpm"]
        @tscorehr = fields['tscorehr']
        @intensity_factor = fields['intensity_factor']
        @calories = fields['calories']
      end
      
      
      def self.find(id, activity='workouts',client=nil)
        new(Connector.new("/plans/#{activity}/fragment/heartrate/#{id}", client).get())

      end
    end
    
  end
end