require 'spec_helper'

describe TodaysPlan::Client do

  let(:username){TodaysPlan.username}
  let(:password){TodaysPlan.password}
  let(:client){TodaysPlan::Client.new(username, password)}
  
  
  it "expect to authenticate" do
    stub_request(:post, TodaysPlan.endpoint+'/auth/login').
      with(:body => "{\"username\":\"#{username}\",\"password\":\"#{password}\",\"token\":true}",
      :headers => {'Accept'=>'application/json',  
        'Content-Type'=>'application/json',}).
      to_return(:status => 200, :body => '{"token":"abc-123"}', :headers => {})
    expect(client.token).to_not be_nil
  end
  
  it "expect to logout" do
    stub_request(:get, TodaysPlan.endpoint+"/auth/logout").
      with(:headers => {
        'Authorization'=>'Bearer abc-123', }).
      to_return(:status => 200, :body => "true", :headers => {})
    expect(client.token).to_not be_nil
    expect(client.logout).to eq "true"
  end

end