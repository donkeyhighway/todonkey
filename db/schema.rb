# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100303230520) do

  create_table "todos", :force => true do |t|
    t.integer  "parent_id"
    t.string   "type",       :limit => 32,  :null => false
    t.integer  "user_id",                   :null => false
    t.string   "detail",     :limit => 512, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["parent_id", "type"], :name => "index_todos_on_parent_id_and_type"
  add_index "todos", ["parent_id"], :name => "index_todos_on_parent_id"
  add_index "todos", ["type"], :name => "index_todos_on_type"

  create_table "users", :force => true do |t|
    t.string   "login",               :limit => 64,                :null => false
    t.string   "email",                                            :null => false
    t.string   "crypted_password",                                 :null => false
    t.string   "password_salt",                                    :null => false
    t.string   "persistence_token",                                :null => false
    t.string   "single_access_token",                              :null => false
    t.string   "perishable_token",                                 :null => false
    t.integer  "login_count",                       :default => 0, :null => false
    t.integer  "failed_login_count",                :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
