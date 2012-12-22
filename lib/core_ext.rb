class ActiveRecord::Base
  def all_errors(sep = "\n")
    self.errors.full_messages.join(sep)
  end
  
  def self.random(n = 1)
    if n >= self.count
      return self.first if n == 1
      return self.all.to_a
    end
    max = self.last.id
    records = []
    begin
      r = self.find_by_id(rand(max))
      records << r if r.present?
      records.uniq!
    end while records.count < n
    return records.first if n == 1
    records
  end
end

module Rails
  def self.load_conf(file)
    YAML.load(File.read(Rails.root.join("config", file)))[Rails.env].with_indifferent_access
  end
end