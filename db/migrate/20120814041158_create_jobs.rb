class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :icon
      t.timestamps
    end
    
    add_column :users, :job_id, :integer
  end
end
