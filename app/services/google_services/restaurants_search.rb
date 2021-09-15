# frozen_string_literal: true

require 'google_api/api'

module GoogleServices
  # Service Wrapper for Google API
  # Calls the Google TextSearch Map API Endpoint for a given query string
  # Returns touple of search results and the next_page_token (used for pagination)
  # [<Results>[Array], <NextPageToken>[String]]
  class RestaurantsSearch
    QUERY_TYPE = 'restaurant'

    def initialize(page_token:, query:)
      @page_token = page_token
      @query = query
    end

    def search
      [
        restaurants_response.results,
        restaurants_response.next_page_token
      ]
    rescue GoogleApi::MapsApi::Errors::TextSearchError, GoogleApi::Errors::RequestError => e
      Rails.logger.error("#{e.class}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))

      []
    end

    def search!
      search.presence || raise(RestaurantsSearchError)
    end

    private

    attr_reader :page_token, :query

    def api_key
      ENV['GOOGLE_MAPS_API_KEY']
    end

    def api
      GoogleApi::Api.new(api_key: api_key)
    end

    def restaurant_search_request
      api.text_search_request(
        query,
        page_token: page_token,
        type: QUERY_TYPE
      )
    end

    def restaurants_response
      @restaurants_response ||= restaurant_search_request
    end
  end
end
