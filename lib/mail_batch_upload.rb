require 'csv'
class MailBatchUpload
  
  attr_accessor :csv
  
  def initialize(new_csv)
    @csv = new_csv
  end
  
  def each
    first = true 
    headers = []
    CSV.foreach(@csv) do |row|
      if first
        headers = row.collect(&:strip).collect(&:downcase).collect(&:underscore)
        first = false
        next
      end
      
      row_hash = {}
      row.each_with_index {|col, idx| h = headers[idx]; row_hash[h] = col.strip }
      
      yield(row_hash.with_indifferent_access)
    end
  end
  
end