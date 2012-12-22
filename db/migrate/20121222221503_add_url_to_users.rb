class AddUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :url, :string
    add_index :users, :url, unique: true
    add_column :groups, :url, :string
    add_index :groups, :url, unique: true
    User.initialize_urls
    Group.initialize_urls
  end
end
