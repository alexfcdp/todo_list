# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'TodoList'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apipie'
  config.translate = false
  config.default_locale = nil

  config.api_controllers_matcher = Rails.root.join('app', 'controllers', 'api', '**', '*.rb')
end
