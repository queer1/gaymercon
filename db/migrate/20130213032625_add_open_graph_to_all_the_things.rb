class AddOpenGraphToAllTheThings < ActiveRecord::Migration
  def change
    add_column :users, :og_id, :string
    add_column :users, :og_broadcast, :boolean, default: true
    add_column :follows, :og_id, :string
    
    add_column :groups, :og_id, :string
    add_column :memberships, :og_id, :string
    add_column :group_posts, :og_id, :string
    add_column :group_comments, :og_id, :string
    
    add_column :panels, :og_id, :string
    add_column :panel_votes, :og_id, :string
    
    add_column :likes, :og_id, :string
    add_column :badges, :og_id, :string
    
  end
end
