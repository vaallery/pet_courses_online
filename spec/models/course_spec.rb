require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:courses_competitions) }
    it { should have_many(:competitions) }
  end
end
