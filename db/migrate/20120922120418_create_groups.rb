class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :kind
      t.text :description
      t.string :site_name
      t.string :site_link
      t.attachment :header
      t.integer :moderator_id
      t.timestamps
    end
  end
end
