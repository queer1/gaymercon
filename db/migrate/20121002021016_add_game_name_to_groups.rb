class AddGameNameToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :game, :string

    add_column :groups, :game_key, :string

  end
end
