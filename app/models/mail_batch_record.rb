class MailBatchRecord < ActiveRecord::Base
  belongs_to :mail_batch
  belongs_to :mail_batch_draft
  
  serialize :info
  
  validates_presence_of :email
  validates_format_of :email, with: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  
  FIELD_REGEX = /\{\{\s*([^\}]+)\s*\}\}/i
  
  def subject
    draft = self.mail_batch_draft || self.mail_batch.latest_draft
    sbj = draft.subject.dup
    self.info.each do |key, val|
      sbj.gsub!(/\{\{\s*(#{key})\s*\}\}/i, val)
    end
    sbj
  end
  
  def body
    draft = self.mail_batch_draft || self.mail_batch.latest_draft
    msg = draft.body.dup
    self.info.each do |key, val|
      msg.gsub!(/\{\{\s*(#{key})\s*\}\}/i, val)
    end
    msg
  end
  
  def transmit
    return if self.sent_at.present?
    UserMailer.mass_mail(self).deliver
    self.sent_at = Time.now
    self.mail_batch_draft_id = self.mail_batch.latest_draft.id
    self.save
  end
end
