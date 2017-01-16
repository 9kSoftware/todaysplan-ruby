module TodaysPlan
  # Public: Exception to throw when there are configuration problems
  class NotConfiguredError < StandardError; end

  # Internal: Base class for TodaysPlan errors
  class TodaysPlanError < StandardError
    attr_reader :code, :resolve

    # Internal: Initialize a error with proper attributes.
    #
    # code    - The Integer code (e.g. 1501).
    # message - The String message, describing the error.
    # resolve - The String description how to fix the error.
    def initialize(code, message, resolve)
      @code = code
      @resolve = resolve

      super "Code #{@code}: #{message}. #{resolve}"
    end
  end

  # Public: Exception which is thrown when TodaysPlan API returns a 400 response.
  class BadRequestError    < TodaysPlanError; end

  # Public: Exception which is thrown when TodaysPlan API returns a 401 response.
  class UnauthorizedError  < TodaysPlanError; end

  # Public: Exception which is thrown when TodaysPlan API returns a 402 response.
  class RequestFailedError < TodaysPlanError; end

  # Public: Exception which is thrown when TodaysPlan API returns a 404 response.
  class NotFoundError      < TodaysPlanError; end

  # Public: Exception which is thrown when TodaysPlan API returns a response which
  # is neither 2xx, nor 4xx. Presumably 5xx.
  class ServerError        < TodaysPlanError; end
end