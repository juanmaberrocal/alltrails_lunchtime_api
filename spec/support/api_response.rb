# frozen_string_literal: true

module ApiResponse
  def response_headers
    response.headers
  end

  def response_body
    response.body
  end

  def json_body
    JSON.parse(response_body)
  end
end

RSpec.configure do |config|
  config.include ApiResponse, type: :request
end
