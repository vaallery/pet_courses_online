FactoryBot.define do
  factory :user do
    transient do
      permissions { [] }
    end
    email { Faker::Internet.email }
    password { 'AAaa11..' }

    trait :confirmed do
      before :create do |user|
        user.skip_confirmation
      end
    end

    before :create do |user, ev|
      if ev.permissions.any?
        role = create(:role)
        create(:users_role, role: role, user: user)

        ev.permissions.each do |permission|
          resource, action, constraints = permission.split(':')
          p = Permission.find_or_create_by(resource: resource, action: action)
          create(:roles_permission, role: role, permission: p, constraints: constraints)
        end
      end
    end
  end
end
