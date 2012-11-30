class SeparateNameFields < ActiveRecord::Migration
  def change
    add_column :donators, :first_name, :string
    add_column :donators, :last_name, :string
    add_column :badges, :first_name, :string
    add_column :badges, :last_name, :string
    
    execute("update donators set first_name=name")
    execute("update badges set first_name=name")
    
    remove_column :donators, :name
    remove_column :badges, :name
  end
end
