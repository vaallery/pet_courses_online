class Seed::Roles
  def self.execute
    puts "*** Преднаполнение таблицы #{::Role.table_name} ***"
    items = [
      { name: :admin, title: 'Админ', description: '' }
    ]

    items.each do |item|
      role = ::Role.find_or_initialize_by(name: item[:name])
      role.assign_attributes(item)
      role.save
    end
  end
end
