class AddPurchaserToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :purchaser_id, :integer
    execute "UPDATE badges SET purchaser_id = user_id WHERE price IS NOT NULL and price > 0 and user_id IS NOT NULL"
  end
end
