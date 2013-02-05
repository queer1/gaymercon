class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.string :klass
      t.integer :like_id
      t.boolean :revoked
      t.timestamps
    end
  end
end
