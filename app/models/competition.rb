class Competition < ApplicationRecord
  has_many :courses_competitions, dependent: :destroy
  has_many :courses, through: :courses_competitions

  validates_presence_of :name
end
