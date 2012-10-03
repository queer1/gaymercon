class AddTwitterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tw_token, :string

    add_column :users, :tw_expires, :time

  end
end
