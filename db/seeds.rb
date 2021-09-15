# frozen_string_literal: true

if Rails.env.development?
  User.find_or_initialize_by(email: 'test@example.com').tap do |user|
    user.name = 'Test User'
    user.password = 'password'
    user.save!
  end
end
