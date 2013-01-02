class MailBatch < ActiveRecord::Base
  belongs_to :user
  has_many :drafts, :class_name => "MailBatchDraft"
  has_many :records, :class_name => "MailBatchRecord"
  
  def latest_draft
    self.drafts.order("created_at desc").first
  end
  
  def sent_count
    self.records.where("sent_at IS NOT NULL and sent_at != '' ").count
  end
  
  def unsent_count
    self.records.where(sent_at: nil).count
  end
end
