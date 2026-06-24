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

  describe "scopes" do
  let(:category) { create(:category) }
  let(:user) { create(:user) }

  let!(:vestido) { create(:listing, title: "Vestido Zara", price_cents: 5990, condition: :used, user: user, category: category) }
  let!(:caro) { create(:listing, title: "iPhone 15", price_cents: 50000, condition: :new_item, user: user, category: category) }

  it "search filtra por titulo" do
    expect(Listing.search("vestido")).to include(vestido)
    expect(Listing.search("vestido")).not_to include(caro)
  end

  it "by_max_price filtra por preco maximo" do
    expect(Listing.by_max_price(10000)).to include(vestido)
    expect(Listing.by_max_price(10000)).not_to include(caro)
  end

  it "by_condition filtra por condicao" do
    expect(Listing.by_condition("used")).to include(vestido)
    expect(Listing.by_condition("used")).not_to include(caro)
  end
end
end
