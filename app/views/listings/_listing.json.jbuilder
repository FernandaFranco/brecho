json.extract! listing, :id, :title, :description, :price_cents, :condition, :status, :user_id, :category_id, :created_at, :updated_at
json.url listing_url(listing, format: :json)
