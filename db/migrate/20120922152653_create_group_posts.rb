class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :kind
      t.string :title
      t.string :content
      t.attachment :image
      t.time :start_time
      t.time :end_time
      t.timestamps
    end
  end
end
