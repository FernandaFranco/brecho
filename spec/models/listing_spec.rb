require 'rails_helper'

RSpec.describe Listing, type: :model do
  describe "associações" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe "validações" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(500) }
    it { should validate_numericality_of(:price_cents).is_greater_than(0) }
  end
end
