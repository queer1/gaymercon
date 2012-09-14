class AddFieldsToPanels < ActiveRecord::Migration
  def change
    add_column :panels, :kind, :string
    add_column :panels, :confirmed, :boolean
  end
end
