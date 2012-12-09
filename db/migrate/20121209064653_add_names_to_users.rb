class AddNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string

    add_column :users, :fb_uid, :string

    add_column :users, :tw_uid, :string

    add_column :users, :about, :text
  end
end
