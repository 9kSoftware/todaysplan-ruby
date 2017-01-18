require 'todays_plan/version'
require 'todays_plan/client'
require 'todays_plan/connector'
require 'todays_plan/user'
require 'todays_plan/activity'
require 'todays_plan/errors'
require 'rest_client'

module TodaysPlan
  
  class << self
    attr_accessor :username,
      :password,
      :endpoint,
      :timeout,
      :logger,
      :debug
      
    def configure(&block)
      raise ArgumentError, "must provide a block" unless block_given?
      block.arity.zero? ? instance_eval(&block) : yield(self)
    end
    
    # set default endpoint
    def endpoint
      @endpoint ||= 'https://whats.todaysplan.com.au/rest'
    end
    
    #set default timeout
    def timeout
      @timeout ||= 120 #rest-client default
    end
    
    #set default logger
    def logger
      if @debug
       @logger = 'stdout'
       return
      end
      @logger ||= nil
    end
    
    def debug
      @debug ||= false
    end
    
  end
end