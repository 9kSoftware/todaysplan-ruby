require 'spec_helper'

describe TodaysPlan::Activity::Summary do

 
  it "find activity" do
    stub_request(:get, "#{TodaysPlan.endpoint}/plans/workouts/fragment/summary/8753794").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, :body => File.read("spec/fixtures/activities/summary.json"), :headers => {})
    activity = TodaysPlan::Activity::Summary.find(8753794)
    expect(activity.min_bpm).to eq 75
  end
  
end