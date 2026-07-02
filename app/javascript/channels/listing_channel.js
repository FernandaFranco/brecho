import consumer from "channels/consumer";

consumer.subscriptions.create(
  {
    channel: "ListingChannel",
    id: document.querySelector("[data-listing-id]")?.dataset.listingId,
  },
  {
    connected() {},
    disconnected() {},
    received(data) {
      const counter = document.querySelector("[data-views-count]");
      if (counter) counter.textContent = data.views_count;
    },
  },
);
