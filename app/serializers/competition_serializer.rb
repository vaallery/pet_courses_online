class CompetitionSerializer < ActiveModel::Serializer
  attributes Competition.column_names.map(&:to_sym)
  attribute :course_ids
end
