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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131216015517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.datetime "entrytime"
    t.integer  "quantity"
    t.integer  "trade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price"
    t.text     "tags",       array: true
  end

  add_index "entries", ["tags"], name: "index_entries_on_tags", using: :gin
  add_index "entries", ["trade_id"], name: "index_entries_on_trade_id", using: :btree

  create_table "quotebases", force: true do |t|
    t.string   "symbol"
    t.string   "yahoo_symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "properties",   default: {}, null: false
  end

  create_table "securities", force: true do |t|
    t.string   "symbol"
    t.string   "security_type"
    t.text     "description"
    t.string   "currency"
    t.decimal  "tick_size"
    t.decimal  "tickval"
    t.integer  "sort_order"
    t.integer  "default_spread"
    t.integer  "decimal_places"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "securities", ["symbol"], name: "index_securities_on_symbol", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trades", force: true do |t|
    t.integer  "user_id"
    t.decimal  "fill"
    t.decimal  "stop"
    t.decimal  "targ1"
    t.decimal  "targ2"
    t.float    "prob1"
    t.float    "prob2"
    t.decimal  "pl"
    t.string   "desc"
    t.string   "comments"
    t.float    "kelly"
    t.boolean  "open"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "stop2"
    t.boolean  "second_target"
    t.float    "sellpct"
    t.text     "market_condition", array: true
    t.string   "symbol"
    t.float    "edge"
  end

  add_index "trades", ["market_condition"], name: "index_trades_on_market_condition", using: :gin
  add_index "trades", ["symbol"], name: "index_trades_on_symbol", using: :btree
  add_index "trades", ["user_id", "created_at"], name: "index_trades_on_user_id_and_created_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.integer  "kelly_fraction"
    t.decimal  "account_size"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
