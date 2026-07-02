class ListingExpirationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    expired_listings = Listing.active.where("created_at < ?", 30.days.ago)

    expired_listings.update_all(status: :inactive)
  end
end
