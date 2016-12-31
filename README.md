[![Build Status](https://travis-ci.org/9kSoftware/todaysplan-ruby.svg?branch=master)](https://travis-ci.org/9kSoftware/todaysplan-ruby)
# todaysplan-ruby
A Ruby Library for TodaysPlan

This library is currently limited to only a few API calls needed.  Feel free to do
Pull Request to include additional calls.

## Installation

Add the gem to your app

```ruby
gem 'todaysplan-ruby'
```

### Usage

To authenticate with TodaysPlan API by setting the username and password variables
```ruby
TodaysPlan.username = 'email@example.com'
TodaysPlan.password = 'secret'
athletes = TodaysPlan::Athletes.all
```
or create a TodaysPlan client and pass the client to the method
```ruby
client = TodaysPlan::Client.new('email@example.com','secret')
athletes = TodaysPlan::Athletes.all(client)
```

### Testing
You can test live data by setting your credentials in todays_plan.yml.  If this file 
exists, live connections can be made and log the response to the console.

```yaml
---
username: 'email@example.com'
password: 'secret'
endpoint: 
timeout: 120 
logger: 'stdout'
debug: true 
```

