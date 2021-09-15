# frozen_string_literal: true

require 'google_api/maps_api/request'
require 'google_api/maps_api/errors/find_place_error'

module GoogleApi
  module MapsApi
    # https://developers.google.com/maps/documentation/places/web-service/search-find-place
    class FindPlace < Request
      # Constants
      URL = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'

      attr_reader :results

      private

      attr_reader :input, :input_type, :fields

      def initialize_params(fields:, input:, input_type:)
        @fields = fields
        @input = input
        @input_type = input_type
      end

      def query_options
        {
          fields: fields,
          input: input,
          inputtype: input_type
        }
      end

      def success_response
        @results = parsed_response['candidates']
      end
    end
  end
end
