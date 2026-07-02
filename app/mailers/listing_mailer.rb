class ListingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.listing_mailer.new_listing_notification.subject
  #
  def new_listing_notification(listing)
    @listing = listing

    mail to: listing.user.email_address, subject: "Seu anúncio '#{listing.title}' foi criado!"
  end
end
