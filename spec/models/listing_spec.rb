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

  describe "photos" do
    it "aceita fotos anexadas" do
      listing = create(:listing)
      listing.photos.attach(
        io: StringIO.new("fake image data"),
        filename: "test.jpg",
        content_type: "image/jpeg"
      )
      expect(listing.photos).to be_attached
    end
  end

  describe "validação de photos" do
  let(:listing) { create(:listing) }

  it "aceita foto valida" do
      listing.photos.attach(
        io: StringIO.new("image data"),
        filename: "test.jpg",
        content_type: "image/jpeg"
      )
      expect(listing).to be_valid
    end

  it "rejeita arquivo que nao e imagem" do
    listing.photos.attach(
      io: StringIO.new("fake"),
      filename: "documento.pdf",
      content_type: "application/pdf"
    )
    expect(listing).not_to be_valid
    expect(listing.errors[:photos]).to include("deve ser JPEG, PNG ou WebP")
  end

  it "rejeita arquivo que e maior que 5MB" do
    large_data = "a" * 6.megabytes
    listing.photos.attach(
      io: StringIO.new(large_data),
      filename: "foto.jpg",
      content_type: "image/jpeg"
    )
    expect(listing).not_to be_valid
    expect(listing.errors[:photos]).to include("deve ser menor que 5MB")
  end
end
end
