class Seed::Permissions
  def self.execute
    puts "*** Преднаполнение таблицы #{::Permission.table_name} ***"
    crud = %i[read create update destroy]
    items = [
      { resource: :author, actions: crud },
      { resource: :course, actions: crud },
      { resource: :competition, actions: crud }
    ].map do |pps|
      pps[:actions].map do |action|
        {
          resource: pps[:resource],
          action: action
        }
      end
    end.flatten

    items.each do |item|
      permission = ::Permission.find_or_initialize_by(resource: item[:resource], action: item[:action])
      permission.assign_attributes(item)
      permission.save
    end
  end
end
