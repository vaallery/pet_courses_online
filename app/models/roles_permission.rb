class RolesPermission < ApplicationRecord
  belongs_to :role
  belongs_to :permission

  def parsed_constraints
    return {} if constraints.blank?

    JSON.parse(constraints)
  end
end
