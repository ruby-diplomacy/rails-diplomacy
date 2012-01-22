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

ActiveRecord::Schema.define(:version => 20120121171014) do

  create_table "chatroom_power_associations", :id => false, :force => true do |t|
    t.integer "chatroom_id"
    t.integer "power_id",    :null => false
  end

  add_index "chatroom_power_associations", ["chatroom_id"], :name => "index_chatroom_power_associations_chatroom"
  add_index "chatroom_power_associations", ["power_id"], :name => "index_chatroom_power_associations_power"

  create_table "chatrooms", :force => true do |t|
    t.integer "game_id", :null => false
  end

  add_index "chatrooms", ["game_id"], :name => "index_chatrooms_game"

  create_table "games", :force => true do |t|
    t.string   "title",      :limit => 50,                :null => false
    t.integer  "status",                   :default => 0, :null => false
    t.datetime "start_time"
    t.integer  "variant_id",                              :null => false
  end

  add_index "games", ["variant_id"], :name => "index_games_variant"

  create_table "messages", :force => true do |t|
    t.string  "text",        :limit => 50
    t.integer "power_id",                  :null => false
    t.integer "chatroom_id",               :null => false
  end

  add_index "messages", ["chatroom_id"], :name => "index_messages_chatroom"
  add_index "messages", ["power_id"], :name => "index_messages_power"

  create_table "powers", :force => true do |t|
    t.string  "name",       :limit => 50, :null => false
    t.integer "variant_id",               :null => false
  end

  add_index "powers", ["name"], :name => "unique_powers_variant", :unique => true
  add_index "powers", ["variant_id"], :name => "index_powers_variant"

  create_table "states", :force => true do |t|
    t.integer "turn",                  :null => false
    t.string  "state",   :limit => 50, :null => false
    t.integer "game_id",               :null => false
  end

  add_index "states", ["game_id"], :name => "index_states_game"

  create_table "user_assignments", :force => true do |t|
    t.integer "game_id",  :null => false
    t.integer "user_id",  :null => false
    t.integer "power_id"
  end

  add_index "user_assignments", ["game_id"], :name => "index_user_assignments_game"
  add_index "user_assignments", ["id"], :name => "unique_user_assignments_key", :unique => true
  add_index "user_assignments", ["power_id"], :name => "index_user_assignments_power"
  add_index "user_assignments", ["power_id"], :name => "unique_user_assignments_power_id", :unique => true
  add_index "user_assignments", ["user_id"], :name => "index_user_assignments_user"

  create_table "users", :force => true do |t|
    t.string "username", :limit => 50, :null => false
  end

  create_table "variants", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

end
