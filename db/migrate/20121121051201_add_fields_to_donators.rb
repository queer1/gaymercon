class AddFieldsToDonators < ActiveRecord::Migration
  def change
    add_column :donators, :notes, :string

  end
end
