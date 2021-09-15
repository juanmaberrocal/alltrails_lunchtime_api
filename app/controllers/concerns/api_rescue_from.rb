# frozen_string_literal: true

module ApiRescueFrom
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :internal_service_error!
  end

  private

  def internal_service_error!(exception)
    log_rescue_exception(exception)

    error!(
      code: 500,
      message: exception.class.name == exception.message ? I18n.t('api.errors.internal_service_error') : exception.message
    )
  end

  def error!(code:, message:)
    render json: {
      message: message,
      status: I18n.t('api.status.error')
    }, status: code
  end

  def log_rescue_exception(exception)
    Rails.logger.error("#{exception.class}: #{exception.message}")
    Rails.logger.debug(exception.backtrace.join("\n"))
  end
end
