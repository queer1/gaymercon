class AddAgeToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :age, :integer

  end
end
