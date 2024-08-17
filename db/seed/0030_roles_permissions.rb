class Seed::RolesPermissions
  class << self
    ########################## Разрешения для ролей IQ-Media ###############################################
    def for_courses
      [
        { role: :admin, permissions: [
          *crud_for(:author),
          *crud_for(:course),
          *crud_for(:competition)
        ] }
      ]
    end

    def execute
      puts "*** Преднаполнение таблицы #{::RolesPermission.table_name} ***"

      items = [
        *for_courses
      ]

      items.each do |item|
        role = ::Role.find_by!(name: item[:role])
        item[:permissions].each do |permission_item|
          permission = Permission.find_by!(resource: permission_item[:resource], action: permission_item[:action])
          RolesPermission.find_or_create_by!(role_id: role.id, permission_id: permission.id, constraints: permission_item[:constraints])
        end
      rescue StandardError => e
        Rails.logger.error "#{e.message} #{item.as_json}"
        puts "#{e.message} #{item.as_json}"
      end
    end

    private

    def crud_for(resource)
      [
        { resource: resource, action: :read, constraints: nil },
        { resource: resource, action: :create, constraints: nil },
        { resource: resource, action: :update, constraints: nil },
        { resource: resource, action: :destroy, constraints: nil }
      ]
    end
  end
end
