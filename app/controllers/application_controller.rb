class ApplicationController < ActionController::API
  include AuthenticableHelper
  include ExceptionHandler
  include FilterSortPagination
  before_action :authenticate!, unless: -> { devise_controller? }
  check_authorization unless: :devise_controller?

  private

  def devise_controller?
    /RailsJwtAuth::.*Controller/.match(self.class.name) ||
      /Auth::.*Controller/.match(self.class.name)
  end
end
