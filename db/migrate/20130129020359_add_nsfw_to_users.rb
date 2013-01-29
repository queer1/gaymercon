class AddNsfwToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nsfw, :boolean

  end
end
