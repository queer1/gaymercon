class CreateGroupComments < ActiveRecord::Migration
  def change
    create_table :group_comments do |t|
      t.integer :user_id
      t.integer :group_post_id
      t.text :content
      t.timestamps
    end
  end
end
