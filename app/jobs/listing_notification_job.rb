class ListingNotificationJob < ApplicationJob
  queue_as :default

  def perform(listing)
    ListingMailer.new_listing_notification(listing).deliver_now
  end
end
