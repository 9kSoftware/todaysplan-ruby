require 'spec_helper'

describe TodaysPlan::Activity::Heartrate do

 
  it "find activity" do
    stub_request(:get, "#{TodaysPlan.endpoint}/plans/workouts/fragment/heartrate/8753794").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, :body => File.read("spec/fixtures/activities/heartrate.json"), :headers => {})
    activity = TodaysPlan::Activity::Heartrate.find(8753794)
    expect(activity.min_bpm).to eq 81
  end
  
end