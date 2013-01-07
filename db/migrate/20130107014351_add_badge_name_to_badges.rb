class AddBadgeNameToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :badge_name, :string
    execute "UPDATE badges LEFT JOIN users ON users.id = badges.user_id SET badges.badge_name = users.name"
  end
end
