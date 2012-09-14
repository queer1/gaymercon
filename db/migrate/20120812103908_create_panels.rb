class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.float :score
      t.timestamps
    end
  end
end
