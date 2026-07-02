require 'rails_helper'

RSpec.describe ListingExpirationJob, type: :job do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  it "marca listings antigos como inativos" do
    old_listing = create(:listing, user: user, category: category, created_at: 31.days.ago)
    recent_listing = create(:listing, user: user, category: category, created_at: 1.day.ago)

    ListingExpirationJob.perform_now

    expect(old_listing.reload.status).to eq("inactive")
    expect(recent_listing.reload.status).to eq("active")
  end
end
