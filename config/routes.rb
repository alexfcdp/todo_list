# frozen_string_literal: true

Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects do
        resources :tasks, shallow: true do
          resources :comments, only: %i[index create destroy], shallow: true
          patch :position, :complete, on: :member
        end
      end
    end
  end
end
