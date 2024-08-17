class CourseSerializer < ActiveModel::Serializer
  attributes Course.column_names.map(&:to_sym)
  attribute :competition_ids

  belongs_to :author
end
