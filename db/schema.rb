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

ActiveRecord::Schema.define(version: 20131206162228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercise_logs", force: true do |t|
    t.integer  "exercise_id"
    t.integer  "routine_log_id"
    t.integer  "rep_count"
    t.decimal  "mass"
    t.string   "mass_units"
    t.decimal  "distance"
    t.string   "distance_units"
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercise_logs", ["exercise_id"], name: "index_exercise_logs_on_exercise_id", using: :btree
  add_index "exercise_logs", ["routine_log_id"], name: "index_exercise_logs_on_routine_log_id", using: :btree

  create_table "exercises", force: true do |t|
    t.string   "slug"
    t.integer  "routine_id"
    t.string   "name"
    t.string   "exercise_type"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exercises", ["routine_id"], name: "index_exercises_on_routine_id", using: :btree
  add_index "exercises", ["slug"], name: "index_exercises_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "preferences", force: true do |t|
    t.integer  "user_id"
    t.string   "mass_units"
    t.string   "distance_units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id", using: :btree

  create_table "routine_logs", force: true do |t|
    t.integer  "routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routine_logs", ["routine_id"], name: "index_routine_logs_on_routine_id", using: :btree

  create_table "routines", force: true do |t|
    t.string   "slug"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routines", ["slug"], name: "index_routines_on_slug", unique: true, using: :btree
  add_index "routines", ["user_id"], name: "index_routines_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["api_token"], name: "index_users_on_api_token", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

end
