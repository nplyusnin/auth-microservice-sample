# frozen_string_literal: true

require_relative 'config/environment'

run Rack::URLMap.new(
  '/v1/signup' => UserRoutes,
  '/v1/login' => SessionRoutes,
  '/v1/auth' => AuthRoutes
)