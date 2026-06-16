class Category < ApplicationRecord
  has_many :listings, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
