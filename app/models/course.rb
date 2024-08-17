class Course < ApplicationRecord
  belongs_to :author
  has_many :courses_competitions, dependent: :destroy
  has_many :competitions, through: :courses_competitions

  validates_presence_of :name

  def change_author
    self.author = closest_author
  end

  def closest_author
    Author.where.not(id: author_id).order("RANDOM()").limit(1)
  end
end
