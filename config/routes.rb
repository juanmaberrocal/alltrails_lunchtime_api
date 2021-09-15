# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :api do
    scope module: :v1 do
      # Non-CRUD
      post 'search', controller: :restaurants, action: :search
    end
  end
end
