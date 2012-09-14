class CreateGraffitis < ActiveRecord::Migration
  def change
    create_table :graffitis do |t|
      t.integer :user_id
      t.integer :tag_id
      t.string :kind
      t.integer :count
      t.timestamps
    end
    
    add_index :graffitis, :user_id
    add_index :graffitis, :tag_id
    add_index :graffitis, :kind
  end
end
