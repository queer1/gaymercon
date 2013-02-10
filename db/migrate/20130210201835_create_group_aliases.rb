class CreateGroupAliases < ActiveRecord::Migration
  def change
    create_table :group_aliases do |t|
      t.integer :group_id
      t.string :name
      t.string :url
      t.timestamps
    end
  end
end
