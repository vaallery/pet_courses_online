require 'rails_helper'

RSpec.describe CoursesCompetition, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
    it { should belong_to(:competition) }
  end
end
