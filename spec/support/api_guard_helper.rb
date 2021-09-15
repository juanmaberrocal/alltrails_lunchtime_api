module ApiGuardHelper
  def current_user(user = nil)
    @current_user ||= (user || User.create(name: 'Test', email: 'test@example.com', password: 'password'))
  end

  def auth_headers(user = nil)
    # This method will return two values which is access token and refresh token.
    access_token, _ = jwt_and_refresh_token(current_user(user), 'user')
    {'Authorization' => "Bearer #{access_token}" }
  end
end

RSpec.configure do |config|
  config.include ApiGuard::Test::ControllerHelper
  %i[request controller].each { |type| config.include ApiGuardHelper, type: type }
end
