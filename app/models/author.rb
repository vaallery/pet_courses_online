class Author < ApplicationRecord
  validates_presence_of :name

  has_many :courses, dependent: :restrict_with_error
  before_destroy :replace_author_for_courses

  private

  def replace_author_for_courses
    courses.each(&:change_author)
  end
end
