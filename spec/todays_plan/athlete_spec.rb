require 'spec_helper'

describe TodaysPlan::Athlete do

  let(:response){File.read("spec/fixtures/athletes/search_response.json")}
  
  it "expect to get all athletes" do
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/users").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => response, :headers => {})
    all = TodaysPlan::Athlete.all()
    expect(all).to be_a(Array)
    expect(all[0]).to be_a(TodaysPlan::Athlete)
    expect(all[0].first_name).to eq "Joe"
    expect(all[0].last_name).to eq "Athlete"
    expect(all[0].coach).to eq 7187033
    expect(all[0].timezone).to eq "US/Mountain"
    expect(all[0].id).to eq 7187033
    expect(all[0].name).to eq "Joe Athlete"
    expect(all[0].email).to eq "joeathlete@example.com"
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

  it "expect to create one athlete" do
    options = {user_email: 'joeathlete@example.com', firstname: 'joe',
      lastname: 'athlete', password:'password', coach_email: 'coach@email.com'}
    # preregister
    stub_request(:get, "#{TodaysPlan.endpoint}/auth/preregister").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "", :headers => {})
    #register
    stub_request(:post, "#{TodaysPlan.endpoint}/auth/register").
      with(:body => '{"email":"joeathlete@example.com","firstname":"joe","lastname":"athlete","password":"password"}',
      :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/athletes/register_response.json"),
      :headers => {})
    #login as new user
    stub_request(:post, TodaysPlan.endpoint+'/auth/login').
      with(:body => "{\"username\":\"joeathlete@example.com\",\"password\":\"password\",\"token\":true}",
      :headers => {'Accept'=>'application/json', 
        'Content-Type'=>'application/json', }).
      to_return(:status => 200, :body => '{"token":"abc-456"}', :headers => {}) 
    #invite the coach
    stub_request(:post, "#{TodaysPlan.endpoint}/users/delegates/invite").
      with(:body => '{"email":"coach@email.com","state":"pending_coach","relationship":"coach"}',
      :headers => {'Accept'=>'application/json', 
        'Authorization'=>'Bearer abc-456', 
        'Content-Type'=>'application/json'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/athletes/invite_response.json"), 
      :headers => {})
    # search for pending invites
    stub_request(:post, "#{TodaysPlan.endpoint}/users/delegates/search/0/100").
      with(:body => '{"state":"pending_coach"}',
      :headers => {'Accept'=>'application/json', 
        'Authorization'=>'Bearer abc-123', 
        'Content-Type'=>'application/json'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/athletes/delegates_response.json"), 
      :headers => {})
    # accept invite
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/invite/accept/98765").
      with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/athletes/accept_response.json"),  
      :headers => {})
    athlete = TodaysPlan::Athlete.create(options)
    expect(athlete.first_name).to eq "joe"
    expect(athlete.last_name).to eq "athlete"
    expect(athlete.email).to eq "joeathlete@example.com"
    expect(athlete.id).to eq(1234)
  end

end