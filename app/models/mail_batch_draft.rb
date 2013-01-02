class MailBatchDraft < ActiveRecord::Base
  belongs_to :mail_batch
  
  FIELD_REGEX = /\{\{\s*([^\}]+)\s*\}\}/i
  
  def fields
    all_fields = ["email"]
    subject.to_s.scan(FIELD_REGEX).each {|res| all_fields << res.first.strip }
    body.to_s.scan(FIELD_REGEX).each {|res| all_fields << res.first.strip }
    all_fields.uniq
  end
end
