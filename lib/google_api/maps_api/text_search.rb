# frozen_string_literal: true

require 'google_api/maps_api/request'
require 'google_api/maps_api/errors/text_search_error'

module MapsApi
  # https://developers.google.com/maps/documentation/places/web-service/search-text
  class TextSearch < Request
    # Constants
    URL = 'https://maps.googleapis.com/maps/api/place/textsearch/json'

    attr_reader :results, :next_page_token

    private

    attr_reader :page_token, :query, :type

    def initialize_params(page_token:, query:, type:)
      @page_token = page_token
      @query = query
      @type = type
    end

    def query_options
      {
        pagetoken: page_token,
        query: query,
        type: type
      }
    end

    def success_response
      @results = parsed_response['results']
      @next_page_token = parsed_response['next_page_token']
    end
  end
end
