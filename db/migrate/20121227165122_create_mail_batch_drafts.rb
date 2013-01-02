class CreateMailBatchDrafts < ActiveRecord::Migration
  def change
    create_table :mail_batch_drafts do |t|
      t.integer :mail_batch_id
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
