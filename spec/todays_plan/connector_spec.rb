require 'spec_helper'

describe TodaysPlan::Connector do

  let(:username){TodaysPlan.username}
  let(:password){TodaysPlan.password}
  let(:client){TodaysPlan::Client.new(username, password)}
  
  
  it "expect create new connect without client" do
    client = double
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    conn = TodaysPlan::Connector.new("/test")
    expect(conn.client).to eq client
    expect(conn.uri).to eq TodaysPlan.endpoint + "/test"
    expect(conn.timeout).to eq TodaysPlan.timeout
  end
  
  it "expect to create new connect with client" do
    client = double(token: 'abc-123', code: 200)
    expect(TodaysPlan::Client).to_not receive(:new)
    TodaysPlan::Connector.new("/test", client)
  end
  
  it "expect rest-client get request" do
    response = double(body: '{"message":"test"}', code: 200)
    client = double(token: 'abc-123')
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    expect(RestClient::Request).to receive(:execute).and_return(response)
    expect(TodaysPlan::Connector.new("/test",).get()).to eq({"message"=>"test"})
  end
  
  it "expect rest-client post request" do
    response = double(body: '{"message":"test"}', code: 201)
    client = double(token: 'abc-123')
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    expect(RestClient::Request).to receive(:execute).and_return(response)
    expect(TodaysPlan::Connector.new("/test",).post()).to eq({"message"=>"test"})
  end
 
  
  it "expect rest-client post raise error empty body" do
    response = double(body: nil, code: 503)
    client = double(token: 'abc-123')
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    expect(RestClient::Request).to receive(:execute).and_return(response)
    expect{TodaysPlan::Connector.new("/test",).post()}.to raise_error(TodaysPlan::ServerError)
  end
  
  it "expect rest-client get raise error empty body" do
    response = double(body: nil, code: 200)
    client = double(token: 'abc-123')
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    expect(RestClient::Request).to receive(:execute).and_return(response)
    expect{TodaysPlan::Connector.new("/test",).get()}.to raise_error(TodaysPlan::ServerError)
  end
  
  it "expect rest-client get raise error 404" do
    client = double(token: 'abc-123')
    allow(RestClient::NotFound).to receive(:body).and_return('{"message":"testing"}')
    allow(RestClient::NotFound).to receive(:code).and_return(404)
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    expect(RestClient::Request).to receive(:execute).and_return(RestClient::NotFound)
    expect{TodaysPlan::Connector.new("/test",).get()}.to raise_error(TodaysPlan::NotFoundError)
  end
  
  it "expect rest-client get raise error 401" do
    response = double('RestClient::Unauthorized',body: '{}', code: 401)
    client = double(token: 'abc-123')
    expect(TodaysPlan::Client).to receive(:new).with(username, password).and_return(client)
    allow(RestClient::Unauthorized).to receive(:body).and_return('{"message":"testing"}')
    allow(RestClient::Unauthorized).to receive(:code).and_return(401)
    expect(RestClient::Request).to receive(:execute).and_return(RestClient::Unauthorized)
    expect{TodaysPlan::Connector.new("/test",).get()}.to raise_error(TodaysPlan::UnauthorizedError)
  end
  
  
end