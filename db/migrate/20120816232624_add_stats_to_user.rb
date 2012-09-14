class AddStatsToUser < ActiveRecord::Migration
  def change
    add_column :users, :level, :integer, default: 1
    add_column :users, :xp, :integer, default: 1
    add_column :users, :skill_points, :integer, default: 46
    
    add_column :users, :strength, :integer, default: 1
    add_column :users, :agility, :integer, default: 1
    add_column :users, :vitality, :integer, default: 1
    add_column :users, :mind, :integer, default: 1
    add_column :users, :luck, :integer, default: 1
  end
end
