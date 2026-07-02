# Preview all emails at http://localhost:3000/rails/mailers/listing_mailer_mailer
class ListingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/listing_mailer_mailer/new_listing_notification
  def new_listing_notification
    ListingMailer.new_listing_notification
  end
end
