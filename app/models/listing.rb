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
end
