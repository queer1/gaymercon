class CreateNicknames < ActiveRecord::Migration
  def change
    create_table :nicknames do |t|
      t.integer :user_id
      t.string :network
      t.string :name
      t.timestamps
    end
  end
end
