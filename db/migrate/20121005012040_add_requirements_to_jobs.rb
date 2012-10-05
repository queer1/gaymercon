class AddRequirementsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :level_requirement, :integer

  end
end
