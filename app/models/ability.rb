# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    user.roles_permissions.preload(:permission).each do |rp|
      constraints = rp.parsed_constraints
      can rp.permission.action.to_sym, rp.permission.model, constraints
    end
  end
end
