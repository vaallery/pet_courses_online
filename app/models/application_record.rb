class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.fill_with(values, find_by: :id)
    values.each do |value|
      item = find_or_initialize_by(find_by => value[find_by])
      item.assign_attributes(value)
      item.save
    end
  end
end
