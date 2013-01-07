# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130107014351) do

  create_table "badges", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "admin_id"
    t.string   "explain"
    t.string   "level"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "postal"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "age"
    t.integer  "price"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "badge_name"
  end

  add_index "badges", ["code"], :name => "index_badges_on_code", :unique => true

  create_table "donators", :force => true do |t|
    t.string   "email"
    t.boolean  "subscribed"
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "notes"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "followed_user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "forum_thread_id"
    t.text     "message"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "forum_threads", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gaymers", :force => true do |t|
    t.string   "email"
    t.string   "city"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "graffitis", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.string   "kind"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "graffitis", ["kind"], :name => "index_graffitis_on_kind"
  add_index "graffitis", ["tag_id"], :name => "index_graffitis_on_tag_id"
  add_index "graffitis", ["user_id"], :name => "index_graffitis_on_user_id"

  create_table "group_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_post_id"
    t.text     "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "group_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "kind"
    t.string   "title"
    t.text     "content"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.text     "description"
    t.string   "site_name"
    t.string   "site_link"
    t.string   "header_file_name"
    t.string   "header_content_type"
    t.integer  "header_file_size"
    t.datetime "header_updated_at"
    t.integer  "moderator_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "game"
    t.string   "game_key"
    t.string   "url"
  end

  add_index "groups", ["url"], :name => "index_groups_on_url", :unique => true

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "level_requirement"
  end

  create_table "mail_batch_drafts", :force => true do |t|
    t.integer  "mail_batch_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "mail_batch_records", :force => true do |t|
    t.integer  "mail_batch_id"
    t.time     "sent_at"
    t.integer  "mail_batch_draft_id"
    t.string   "email"
    t.text     "info"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "mail_batches", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.text     "content"
    t.boolean  "read",         :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "messages", ["from_user_id"], :name => "index_messages_on_from_user_id"
  add_index "messages", ["to_user_id"], :name => "index_messages_on_to_user_id"

  create_table "nicknames", :force => true do |t|
    t.integer  "user_id"
    t.string   "network"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "panel_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "panel_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "panelists", :force => true do |t|
    t.string   "panel_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "panels", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.float    "score"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
    t.string   "kind"
    t.boolean  "confirmed"
  end

  create_table "stripe_payments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "token"
    t.string   "description"
    t.string   "stripe_id"
    t.boolean  "paid"
    t.boolean  "refunded"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "donator_id"
    t.integer  "badge_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "user_alerts", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "fb_token"
    t.time     "fb_expires"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "role",                   :default => "user"
    t.integer  "job_id"
    t.string   "provider"
    t.string   "uid"
    t.integer  "xp",                     :default => 1
    t.integer  "skill_points",           :default => 46
    t.integer  "strength",               :default => 1
    t.integer  "agility",                :default => 1
    t.integer  "vitality",               :default => 1
    t.integer  "mind",                   :default => 1
    t.integer  "luck",                   :default => 1
    t.boolean  "disable_emails"
    t.boolean  "disable_pm_emails"
    t.string   "tw_token"
    t.time     "tw_expires"
    t.string   "username"
    t.string   "fb_uid"
    t.string   "tw_uid"
    t.text     "about"
    t.string   "url"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["url"], :name => "index_users_on_url", :unique => true

end
