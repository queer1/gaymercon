class AddEmailFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string

    add_column :users, :disable_emails, :boolean

    add_column :users, :disable_pm_emails, :boolean

  end
end
