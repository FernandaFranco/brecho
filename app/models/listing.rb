class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  # has_many :photos, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :price_cents, numericality: { greater_than: 0 }

  enum :condition, { new_item: 0, used: 1, refurbished: 2 }
  enum :status, { active: 0, sold: 1, inactive: 2 }

  scope :recent, -> { order(created_at: :desc) }

  scope :search, ->(query) { where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") if query.present? }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_condition, ->(condition) { where(condition: condition) if condition.present? }
  scope :by_max_price, ->(max_price) { where("price_cents <= ?", max_price) if max_price.present? }
end
