class CreateGaymers < ActiveRecord::Migration
  def change
    create_table :gaymers do |t|
      t.string :email
      t.string :city
      t.integer :age
      t.timestamps
    end
  end
end
