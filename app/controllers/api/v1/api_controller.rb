# frozen_string_literal: true

module Api
  module V1
    # Base Controller Class for all API V1 Controllers
    class ApiController < ApplicationController
      include ApiRescueFrom

      before_action :set_default_response_format
      before_action :authenticate_and_set_user

      private

      def set_default_response_format
        request.format = :json unless params[:format]
      end
    end
  end
end
