class CreateCoursesCompetitions < ActiveRecord::Migration[7.2]
  def change
    create_table :courses_competitions do |t|
      t.references :course, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
