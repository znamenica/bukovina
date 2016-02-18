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

ActiveRecord::Schema.define(version: 20160209213700) do

  create_table "memories", force: :cascade do |t|
    t.string   "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_name"], name: "index_memories_on_short_name", unique: true
  end

  create_table "memory_names", force: :cascade do |t|
    t.integer  "memory_id",              null: false
    t.integer  "name_id",                null: false
    t.integer  "state"
    t.integer  "feasibly",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "mode"
    t.index ["memory_id", "name_id", "state"], name: "index_memory_names_on_memory_id_and_name_id_and_state", unique: true
  end

  create_table "names", force: :cascade do |t|
    t.string   "text",                       null: false
    t.string   "type",          default: "", null: false
    t.integer  "language_code",              null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "similar_to_id"
    t.index ["text", "type", "language_code"], name: "index_names_on_text_and_type_and_language_code", unique: true
  end

end
