# frozen_string_literal: true

# Generic Classes
require 'google_api/errors/request_error'

# Specific Request APIs
require 'google_api/maps_api/find_place'
require 'google_api/maps_api/text_search'

module GoogleApi
  # Base API class
  # Use this an entry point to call specific Google API Endpoints
  class Api
    def initialize(api_key:)
      @api_key = api_key
    end

    def find_place_request(input, fields:, input_type:)
      MapsApi::FindPlace.new(
        api_key: api_key,
        fields: fields,
        input: input,
        input_type: input_type
      ).perform
    end

    def text_search_request(query, page_token:, type:)
      MapsApi::TextSearch.new(
        api_key: api_key,
        page_token: page_token,
        query: query,
        type: type
      ).perform
    end

    private

    attr_reader :api_key
  end
end
