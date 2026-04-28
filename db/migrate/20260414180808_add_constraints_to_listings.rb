class AddConstraintsToListings < ActiveRecord::Migration[8.1]
  def change
    change_column_null :listings, :title, false
    change_column_null :listings, :price_cents, false
    change_column_null :listings, :condition, false
    change_column_null :listings, :status, false

    change_column_default :listings, :condition, 0
    change_column_default :listings, :status, 0

    add_index :listings, :status
  end
end
