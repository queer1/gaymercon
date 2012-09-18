class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :code
      t.integer :user_id
      t.integer :admin_id
      t.string :explain
      t.string :level
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :province
      t.string :country
      t.string :postal
      t.timestamps
    end
    
    add_index :badges, :code, unique: true
  end
end
