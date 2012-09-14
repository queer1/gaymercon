class CreateForumPosts < ActiveRecord::Migration
  def change
    create_table :forum_posts do |t|
      t.integer :user_id
      t.integer :forum_thread_id
      t.text :message
      t.timestamps
    end
  end
end
