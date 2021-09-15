# frozen_string_literal: true

module Api
  module V1
    # Search for Restaurants through Google API
    class RestaurantsController < ApiController
      # Non-CRUD
      # POST /search
      # params:
      # * query [String]: query string used for the Google Text Search API
      # response:
      # * [Array]
      def search
        @restaurants, next_page_token = GoogleServices::RestaurantsSearch.new(
          page_token: search_params[:page_token],
          query: search_params[:query]
        ).search!

        response.headers['X-Next-Page-Token'] = next_page_token
      end

      private

      def search_params
        params.permit(:page_token, :query)
      end
    end
  end
end
