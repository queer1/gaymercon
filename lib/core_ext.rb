class ActiveRecord::Base
  def all_errors(sep = "\n")
    self.errors.full_messages.join(sep)
  end
end