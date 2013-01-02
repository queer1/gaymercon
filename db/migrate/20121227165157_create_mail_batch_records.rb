class CreateMailBatchRecords < ActiveRecord::Migration
  def change
    create_table :mail_batch_records do |t|
      t.integer :mail_batch_id
      t.time :sent_at
      t.integer :mail_batch_draft_id
      t.string :email
      t.text :info
      t.timestamps
    end
  end
end
