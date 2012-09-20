class CreateDonators < ActiveRecord::Migration
  def change
    create_table :donators do |t|
      t.string :name
      t.string :email
      t.boolean :subscribed
      t.integer :amount
      t.integer :user_id
      t.timestamps
    end
    
    add_column :stripe_payments, :donator_id, :integer
  end
end
