# frozen_string_literal: true

SWAGGER_DOCUMENTS = %i[courses].freeze

Rswag::Ui.configure do |c|
  SWAGGER_DOCUMENTS.map do |file|
    path = File.join(Rails.root, "swagger", "#{file}.yaml")
    next unless File.exist?(path)

    c.openapi_endpoint "/api-docs/#{File.basename(path)}", YAML.load_file(path)["info"]["title"]
  end

  c.basic_auth_enabled = true
  c.basic_auth_credentials "admin", "secret!"
end
