require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "associacoes" do
    it { should have_many(:listings).dependent(:restrict_with_error) }
  end

  describe "validacoes" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_uniqueness_of(:name) }
  end
end
