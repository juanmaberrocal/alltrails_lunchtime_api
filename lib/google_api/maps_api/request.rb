# frozen_string_literal: true

require 'google_api/errors/request_error'

module GoogleApi
  module MapsApi
    # Base API Request class
    # This handles defining all the necessary methods to initialize and perform a request
    # Specific request should inherit from this class and will only need to define:
    # * initialize_params
    # * query_options
    # * success_response
    class Request
      # Constants
      METHOD = 'get'
      SUCCESS_RESPONSE = 'OK'

      attr_reader :places

      def initialize(api_key:, **kwargs)
        @api_key = api_key
        initialize_params(**kwargs)
      end

      def perform
        perform_request
        self
      end

      private

      attr_reader :api_key

      def request
        HTTParty.send(self.class::METHOD, self.class::URL, request_options)
      end

      def request_options
        {
          query: request_query_options
        }.compact
      end

      def request_query_options
        query_options.merge(key: api_key).compact
      end

      def perform_request
        @response = request

        error_request! unless @response.success?
        error_response! unless success_status?
        success_response
      end

      def parsed_response
        @parsed_response ||= @response.parsed_response
      end

      def success_status?
        parsed_response['status'] == self.class::SUCCESS_RESPONSE
      end

      def error_response!
        raise error_klass, parsed_response['error_message']
      end

      def error_klass
        "GoogleApi::MapsApi::Errors::#{self.class.name.demodulize}Error".classify.constantize
      end

      def error_request!
        raise(GoogleApi::Errors::RequestError)
      end

      # Methods to be implement by child class:
      def initialize_params
        raise NoMethodError, 'initialize_params not implemented'
      end

      def query_options
        raise NoMethodError, 'success_response not implemented'
      end

      def success_response
        raise NoMethodError, 'success_response not implemented'
      end
    end
  end
end
