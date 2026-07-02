require 'rails_helper'

RSpec.describe ListingNotificationJob, type: :job do
  describe "new_listing_notification_job" do
    let(:listing) { create(:listing) }

    it "enfilera o email de notificacao" do
       mail = double("mail")
expect(ListingMailer).to receive(:new_listing_notification).with(listing).and_return(mail)
expect(mail).to receive(:deliver_now)
ListingNotificationJob.perform_now(listing)
    end
  end
end
