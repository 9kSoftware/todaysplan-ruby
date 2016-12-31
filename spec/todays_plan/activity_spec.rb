require 'spec_helper'

describe TodaysPlan::Activity do


  let(:json){File.read("spec/fixtures/activities/incomplete.json")}
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
 
end