class User < ApplicationRecord
  include RailsJwtAuth::Authenticatable
  # include RailsJwtAuth::Authenticatable
  # include RailsJwtAuth::Confirmable
  # include RailsJwtAuth::Recoverable
  # include RailsJwtAuth::Trackable
  # include RailsJwtAuth::Invitable
  # include RailsJwtAuth::Lockable

  has_many :users_roles, dependent: :destroy
  has_many :roles, through: :users_roles
  has_many :roles_permissions, through: :roles

  validates :email, presence: true,
            uniqueness: true,
            format: URI::MailTo::EMAIL_REGEXP
end
