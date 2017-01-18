require 'spec_helper'

describe TodaysPlan::User do

  let(:response){File.read("spec/fixtures/users/search_response.json")}
  
  it "expect to get all athletes" do
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/users").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => response, :headers => {})
    users = TodaysPlan::User.all()
    expect(users).to be_a(Array)
    expect(users[0]).to be_a(TodaysPlan::User)
    expect(users[0].first_name).to eq "Joe"
    expect(users[0].last_name).to eq "Athlete"
    expect(users[0].coach).to eq 7187033
    expect(users[0].timezone).to eq "US/Mountain"
    expect(users[0].id).to eq 7187033
    expect(users[0].name).to eq "Joe Athlete"
    expect(users[0].email).to eq "joeathlete@example.com"
  end
  
  it "expect to get one athlete" do
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/users").
      with(:headers => {'Accept'=>'application/json',  
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => response, :headers => {})
    user = TodaysPlan::User.find(7187033)
    expect(user).to be_a(TodaysPlan::User)
    expect(user).to respond_to(:first_name)
    expect(user).to respond_to(:last_name)
    expect(user).to respond_to(:coach)
    expect(user).to respond_to(:timezone)
    expect(user).to respond_to(:id)
    expect(user).to respond_to(:name)
    expect(user).to respond_to(:email)
    expect(user).to respond_to(:dob)
    expect(user).to respond_to(:country)
  end

  it "register user" do
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
      :body => File.read("spec/fixtures/users/register_response.json"),
      :headers => {})
    
    user = TodaysPlan::User.register(options)
    expect(user.first_name).to eq "joe"
    expect(user.last_name).to eq "athlete"
    expect(user.email).to eq "joeathlete@example.com"
    expect(user.id).to eq(1234)
  end
  
  it "invite delegate" do
    options = { relationship: 'coach', state: 'pending_coach', email: 'coach@email.com'}
    #invite the coach
    stub_request(:post, "#{TodaysPlan.endpoint}/users/delegates/invite").
      with(:body => '{"email":"coach@email.com","state":"pending_coach","relationship":"coach"}',
      :headers => {'Accept'=>'application/json', 
        'Authorization'=>'Bearer abc-123', 
        'Content-Type'=>'application/json'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/users/invite_response.json"), 
      :headers => {})
    invite = TodaysPlan::User.invite(options)
    expect(invite["id"]).to eq 8765
  end 
  
  it "accept invite" do
    options = { state: 'pending_coach'}
    # search for pending invites
    stub_request(:post, "#{TodaysPlan.endpoint}/users/delegates/search/0/100").
      with(:body => '{"state":"pending_coach"}',
      :headers => {'Accept'=>'application/json', 
        'Authorization'=>'Bearer abc-123', 
        'Content-Type'=>'application/json'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/users/delegates_response.json"), 
      :headers => {})
    # accept invite
    stub_request(:get, "#{TodaysPlan.endpoint}/users/delegates/invite/accept/98765").
      with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Bearer abc-123'}).
      to_return(:status => 200, 
      :body => File.read("spec/fixtures/users/accept_response.json"),  
      :headers => {})
    users = TodaysPlan::User.accept_invites(options)
    expect(users[0].id).to eq 7189071
  end

end