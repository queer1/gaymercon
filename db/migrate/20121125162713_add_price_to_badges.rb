class AddPriceToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :price, :integer
    add_column :stripe_payments, :badge_id, :integer
  end
end
