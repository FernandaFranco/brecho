class ListingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "listing_#{params[:id]}"
  end

  def unsubscribed
  end
end
