class Job < ActiveRecord::Base
  
  def icon_path
    File.join("/system", "jobs", self.icon)
  end
end
