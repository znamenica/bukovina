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

ActiveRecord::Schema.define(version: 20160511162000) do

  create_table "canto_memories", force: :cascade do |t|
    t.integer "canto_id",  null: false
    t.integer "memory_id", null: false
    t.index ["canto_id", "memory_id"], name: "canto_memories_index", unique: true
  end

  create_table "cantoes", force: :cascade do |t|
    t.text     "text"
    t.string   "prosomeion_title"
    t.string   "language_code",    null: false
    t.integer  "tone"
    t.string   "type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
    t.string   "alphabeth_code",   null: false
    t.string   "author"
    t.string   "description"
    t.string   "ref_title"
    t.index ["title", "language_code"], name: "index_cantoes_on_title_and_language_code"
  end

  create_table "descriptions", force: :cascade do |t|
    t.string   "text",             null: false
    t.string   "language_code",    null: false
    t.integer  "describable_id",   null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "describable_type", null: false
    t.string   "alphabeth_code",   null: false
    t.index ["describable_id", "describable_type", "alphabeth_code"], name: "describable_alphabeth_index", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string   "happened_at"
    t.string   "subject"
    t.integer  "memory_id",   null: false
    t.string   "type",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["subject", "type", "memory_id"], name: "index_events_on_subject_and_type_and_memory_id"
  end

  create_table "links", force: :cascade do |t|
    t.string   "url",            null: false
    t.string   "language_code"
    t.integer  "info_id",        null: false
    t.string   "type",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "alphabeth_code"
    t.string   "info_type"
  end

  create_table "memories", force: :cascade do |t|
    t.string   "short_name", null: false
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
    t.string   "text",                        null: false
    t.string   "type",           default: "", null: false
    t.string   "language_code",               null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "similar_to_id"
    t.string   "alphabeth_code",              null: false
    t.index ["text", "type", "alphabeth_code"], name: "index_names_on_text_and_type_and_alphabeth_code", unique: true
  end

  create_table "service_cantoes", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "canto_id",   null: false
    t.index ["service_id", "canto_id"], name: "index_service_cantoes_on_service_id_and_canto_id", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",           null: false
    t.string   "language_code",  null: false
    t.integer  "info_id",        null: false
    t.string   "type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "alphabeth_code", null: false
    t.text     "text"
    t.string   "text_format"
    t.string   "gospel"
    t.string   "apostle"
    t.string   "author"
    t.string   "source"
    t.string   "description"
    t.string   "info_type"
    t.index ["name", "alphabeth_code"], name: "index_services_on_name_and_alphabeth_code", unique: true
  end

end
