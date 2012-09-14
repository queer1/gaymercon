class RemoveLevel < ActiveRecord::Migration
  def up
    remove_column :users, :level
  end

  def down
    add_column :users, :level, :integer
  end
end
