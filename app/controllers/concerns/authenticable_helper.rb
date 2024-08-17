# frozen_string_literal: true

module AuthenticableHelper
  include ActionController::Cookies
  include RailsJwtAuth::AuthenticableHelper

  def get_jwt_from_request # rubocop:disable Naming/AccessorMethodName
    request.env["HTTP_AUTHORIZATION"]&.split&.last ||
      request.cookie_jar["Authorization"]&.split&.last
  end
end
