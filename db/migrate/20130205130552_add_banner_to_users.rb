class AddBannerToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :header
  end
end
