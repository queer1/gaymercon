class FixGroupPostContent < ActiveRecord::Migration
  def up
    change_column :group_posts, :content, :text
  end

  def down
  end
end
