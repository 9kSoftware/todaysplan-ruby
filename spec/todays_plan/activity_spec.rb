require 'spec_helper'

describe TodaysPlan::Activity do


  #let(:json){File.read("spec/fixtures/activities/incomplete.json")}
  let(:json){'{"criteria":{"fromTs":1482735600000.0,"toTs":1486364400000.0,"userIds":[7184519]},"fields":["scheduled.name","scheduled.day","workout","state","reason"],"opts":1}'}
  let(:response){File.read("spec/fixtures/activities/incomplete_response.json")}
  
  it "expect to get incomplete activites" do
    
    stub_request(:post, "#{TodaysPlan.endpoint}/users/activities/search/0/100/").
      with(:body => json,
      :headers => {'Accept'=>'application/json', 
        'Authorization'=>'Bearer abc-123',  
        'Content-Type'=>'application/json', }).
      to_return(:status => 200, :body => response, :headers => {})
    all = TodaysPlan::Activity.all(json,0,100)
    expect(all).to be_a(Array)
    expect(all[0]).to be_a(TodaysPlan::Activity)
  end
 
  it "find activity" do
    stub_request(:get, "#{TodaysPlan.endpoint}/plans/workouts/detailed/8753794").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, :body => File.read("spec/fixtures/activities/activity.json"), :headers => {})
    activity = TodaysPlan::Activity.find(8753794)
    expect(activity.id).to eq 8753794
  end
  
end