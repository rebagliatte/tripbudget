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

ActiveRecord::Schema.define(:version => 20121013003537) do

  create_table "alternatives", :force => true do |t|
    t.decimal  "cost",       :default => 0.0,          :null => false
    t.string   "person_gap", :default => "per_person", :null => false
    t.string   "time_gap",   :default => "per_day",    :null => false
    t.integer  "expense_id"
    t.boolean  "is_checked"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "body",         :default => ""
    t.integer  "expense_id",                   :null => false
    t.integer  "traveller_id",                 :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "destinations", :force => true do |t|
    t.string   "name",           :default => "", :null => false
    t.string   "google_address", :default => ""
    t.date     "from_date"
    t.date     "to_date"
    t.integer  "trip_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "expenses", :force => true do |t|
    t.string   "name",           :default => "", :null => false
    t.string   "category",       :default => ""
    t.integer  "destination_id",                 :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "travellers", :force => true do |t|
    t.string   "nickname",    :default => "", :null => false
    t.string   "twitter_uid"
    t.string   "email",       :default => ""
    t.string   "name",        :default => ""
    t.string   "checksum",    :default => ""
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "trips", :force => true do |t|
    t.string   "name",        :default => "", :null => false
    t.text     "description", :default => ""
    t.boolean  "is_public"
    t.integer  "owner_id",                    :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

end