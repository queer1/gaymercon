class CreatePanelists < ActiveRecord::Migration
  def change
    create_table :panelists do |t|
      t.string :panel_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :province
      t.string :country
      t.integer :age
      t.timestamps
    end
  end
end
