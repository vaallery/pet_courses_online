require 'rails_helper'

RSpec.describe Competition, type: :model do
  describe 'associations' do
    it { should have_many(:courses_competitions) }
    it { should have_many(:courses) }
  end
end
