class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :fb_token, :string
    add_column :users, :fb_expires, :time
  end
end
