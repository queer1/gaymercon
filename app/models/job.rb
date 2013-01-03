class Job < ActiveRecord::Base
  
  def icon_path
    File.join("/system", "jobs", self.icon)
  end
  
  def self.for_user(user)
    jobs = []
    jobs += Job.where("level_requirement IS NOT NULL and level_requirement <= ?", user.level).all
    jobs += Job.where("level_requirement IS NULL")
    
    jobs
  end
  
  def self.new_jobs
    Job.where("level_requirement IS NULL OR level_requirement = 0").all
  end
  
  def self.avatar(name)
    j = self.where(name: name).first
    return j.present? ? j.icon_path : "default-user.gif"
  end
end
