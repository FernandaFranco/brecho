require 'rails_helper'

RSpec.describe "/listings", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  let(:valid_attributes) do
    { title: "Vestido Zara", description: "Otimo estado", price_cents: 5990, condition: "used", category_id: category.id }
  end

  let(:invalid_attributes) do
    { title: "", description: "", price_cents: -1 }
  end

  before { sign_in(user) }

  describe "GET /index" do
    it "renders a successful response" do
      get listings_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      listing = create(:listing, user: user)
      get listing_url(listing)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_listing_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Listing" do
        expect {
          post listings_url, params: { listing: valid_attributes }
        }.to change(Listing, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Listing" do
        expect {
          post listings_url, params: { listing: invalid_attributes }
        }.to change(Listing, :count).by(0)
      end
    end
  end
end
