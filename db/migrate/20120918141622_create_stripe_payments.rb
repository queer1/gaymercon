class CreateStripePayments < ActiveRecord::Migration
  def change
    create_table :stripe_payments do |t|
      t.integer :user_id
      t.integer :amount
      t.string :token
      t.string :description
      t.string :stripe_id
      t.boolean :paid
      t.boolean :refunded
      t.timestamps
    end
  end
end
