require "rails_helper"

RSpec.describe ListingMailer, type: :mailer do
  describe "new_listing_notification" do
    let(:listing) { create(:listing) }
    let(:mail) { ListingMailer.new_listing_notification(listing) }

    it "envia para o dono do listing" do
      expect(mail.to).to eq([ listing.user.email_address ])
    end

    it "tem o titulo do listing no subject" do
      expect(mail.subject).to include(listing.title)
    end

    it "inclui o titulo no body" do
      expect(mail.body.encoded).to include(listing.title)
    end
  end
end
