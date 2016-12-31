require 'shoulda-matchers'
require 'todays_plan'
require 'webmock/rspec'


if (File.exists?('todays_plan.yml'))
  CONFIG=YAML.load(ERB.new(File.read("todays_plan.yml")).result)
end
TodaysPlan.configure do |config|
  config.username = CONFIG["username"] ||= 'id'
  config.password = CONFIG["password"] ||= 'secret'
  #config.endpoint = 'https://whats.todaysplan.com.au/rest/'
  config.timeout = CONFIG["timeout"]
  config.logger = CONFIG["logger"]
  config.debug = CONFIG["debug"]
end

WebMock.allow_net_connect! if TodaysPlan.debug

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.before {
    stub_request(:post, TodaysPlan.endpoint+'/auth/login').
      with(:body => "{\"username\":\"#{TodaysPlan.username}\",\"password\":\"#{TodaysPlan.password}\",\"token\":true}",
      :headers => {'Accept'=>'application/json', 
        'Content-Type'=>'application/json', }).
      to_return(:status => 200, :body => '{"token":"abc-123"}', :headers => {}) unless TodaysPlan.debug
  }
end