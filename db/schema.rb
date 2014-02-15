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

ActiveRecord::Schema.define(:version => 20140114201120) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "categories_projects", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "project_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization_name"
    t.string   "email"
    t.string   "country"
    t.text     "remarks"
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "logo"
    t.string   "website"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "contacts_projects", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "project_id"
  end

  create_table "membershipments", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "admin_id"
    t.integer  "plan_id",      :default => 1
    t.string   "color_scheme"
    t.string   "currency"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "project_id"
    t.float    "rate"
    t.string   "recurring"
    t.datetime "expected_payment_date"
    t.float    "number_of_hours",       :default => 0.0
    t.float    "number_of_months",      :default => 0.0
    t.datetime "start_date"
    t.boolean  "completed"
    t.datetime "completed_date"
    t.integer  "client_id"
    t.string   "description"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "type"
    t.datetime "billed_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "max_users"
    t.integer  "max_projects"
    t.integer  "max_contacts"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "amount",           :default => 0
    t.string   "currency",         :default => "EUR"
    t.string   "interval",         :default => "1 MONTH"
    t.string   "paymill_offer_id", :default => ""
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.integer  "organization_id"
    t.integer  "estimated_value"
    t.integer  "category_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "statuses", :force => true do |t|
    t.string   "text"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tmp_uploads", :force => true do |t|
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                   :default => "", :null => false
    t.string   "encrypted_password",      :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "avatar_url"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "paymill_client_id",       :default => ""
    t.string   "paymill_subscription_id", :default => ""
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
