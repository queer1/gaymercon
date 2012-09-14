class CreatePanelVotes < ActiveRecord::Migration
  def change
    create_table :panel_votes do |t|
      t.integer :user_id
      t.integer :panel_id
      t.integer :value
      t.timestamps
    end
  end
end