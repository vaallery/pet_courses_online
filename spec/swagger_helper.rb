# frozen_string_literal: true

require 'rails_helper'
require_relative 'schemas/swagger_schema'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s
  config.openapi_format = :yaml
  config.openapi_specs = SwaggerSchema.global_schema
end
