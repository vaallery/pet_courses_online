class AuthorSerializer < ActiveModel::Serializer
  attributes Author.column_names.map(&:to_sym)
  attribute :course_ids
end
