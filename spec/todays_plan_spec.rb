require 'spec_helper'

describe TodaysPlan do


  it "should pass the class back to the given block" do
    TodaysPlan.configure do |plaid_rails|
      expect(TodaysPlan).to eq plaid_rails
    end
  end
    
  it "expect default endpoint" do
    expect(TodaysPlan.endpoint).to eq 'https://whats.todaysplan.com.au/rest'
  end
  
  it "expect default timeout" do
    expect(TodaysPlan.timeout).to eq 120
  end

  it "expect default logger" do
    expect(TodaysPlan.logger).to be_nil
  end

  it "expect default debug" do
    expect(TodaysPlan.debug).to be false
  end
end