# frozen_string_literal: true

require 'rails_helper'

module AuthHelper
  def json
    JSON.parse response.body, symbolize_names: true
  end
end

RSpec.shared_context 'set_authorization' do
  let(:token) do
    return nil unless defined? current_user
    current_user.regenerate_auth_token
    "Bearer #{RailsJwtAuth::JwtManager.encode(current_user.to_token_payload)}"
  end

  let(:Authorization) { token }

  let(:current_user) { create(:user, permissions: current_permissions) }
  let(:current_permissions) { [] }
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
  config.include_context "set_authorization", type: :request
end
