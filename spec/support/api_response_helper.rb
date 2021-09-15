# frozen_string_literal: true

module ApiResponseHelper
  delegate :headers, to: :response, prefix: true

  delegate :body, to: :response, prefix: true

  def json_body
    JSON.parse(response_body)
  end
end

RSpec.configure do |config|
  config.include ApiResponseHelper, type: :request
end
