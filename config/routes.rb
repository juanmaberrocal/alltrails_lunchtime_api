# frozen_string_literal: true

Rails.application.routes.draw do
  # API (Versioned)
  scope module: :api do
    scope module: :v1 do
      # Non-CRUD
      post 'search', controller: :restaurants, action: :search
    end
  end

  # Authentication (JWT Sign in/out)
  api_guard_scope 'users' do
    post 'sign_in' => 'api_guard/authentication#create'
    delete 'sign_out' => 'api_guard/authentication#destroy'
  end
end
