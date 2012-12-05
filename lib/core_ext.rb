class ActiveRecord::Base
  def all_errors(sep = "\n")
    self.errors.full_messages.join(sep)
  end
end

class String
  def to_url
    self.downcase.gsub(/\W/, '-').gsub(/-+/, '-').gsub(/^-+|-+$/, '')
  end
end

module Rails
  def self.load_conf(file)
    YAML.load(File.read(Rails.root.join("config", file)))[Rails.env].with_indifferent_access
  end
end