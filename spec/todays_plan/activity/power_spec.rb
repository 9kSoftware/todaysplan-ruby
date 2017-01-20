require 'spec_helper'

describe TodaysPlan::Activity::Power do

 
  it "find activity" do
    stub_request(:get, "#{TodaysPlan.endpoint}/plans/workouts/fragment/power/8753794").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, :body => File.read("spec/fixtures/activities/power.json"), :headers => {})
    activity = TodaysPlan::Activity::Power.find(8753794)
    expect(activity.avg_watts).to eq 235
  end
  
end