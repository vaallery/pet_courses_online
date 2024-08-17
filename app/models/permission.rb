class Permission < ApplicationRecord
  def model
    resource.camelize.singularize.constantize
  rescue StandardError => _e
    ""
  end
end
