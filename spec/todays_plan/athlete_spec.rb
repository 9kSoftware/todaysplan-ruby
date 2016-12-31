require 'spec_helper'

describe TodaysPlan::Athlete do

  let(:response){File.read("spec/fixtures/athletes/response.json")}
  
  it "expect to get all athletes" do
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/users").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => response, :headers => {})
    all = TodaysPlan::Athlete.all()
    expect(all).to be_a(Array)
    expect(all[0]).to be_a(TodaysPlan::Athlete)
    expect(all[0].first_name).to_not be_nil
    expect(all[0].last_name).to_not be_nil
    expect(all[0].coach).to_not be_nil
    expect(all[0].timezone).to_not be_nil
    expect(all[0].id).to_not be_nil
    expect(all[0].name).to_not be_nil
    expect(all[0].email).to_not be_nil
  end
  
  it "expect to get one athlete" do
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/users").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => response, :headers => {})
    athlete = TodaysPlan::Athlete.find(7187033)
    expect(athlete).to be_a(TodaysPlan::Athlete)
    expect(athlete).to respond_to(:first_name)
    expect(athlete).to respond_to(:last_name)
    expect(athlete).to respond_to(:coach)
    expect(athlete).to respond_to(:timezone)
    expect(athlete).to respond_to(:id)
    expect(athlete).to respond_to(:name)
    expect(athlete).to respond_to(:email)
    expect(athlete).to respond_to(:dob)
  end


end