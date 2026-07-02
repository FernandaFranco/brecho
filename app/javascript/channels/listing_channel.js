import consumer from "channels/consumer";

const listingId =
  document.querySelector("[data-listing-id]")?.dataset.listingId;

if (listingId) {
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
}
