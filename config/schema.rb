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

ActiveRecord::Schema.define(version: 20171128133800) do

  create_table "calendaries", force: :cascade do |t|
    t.string "date"
    t.string "language_code"
    t.string "alphabeth_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "place_id"
    t.string "author_name"
    t.string "council"
    t.boolean "licit", default: false
  end

  create_table "canto_memories", force: :cascade do |t|
    t.integer "canto_id", null: false
    t.integer "memory_id", null: false
    t.index ["canto_id", "memory_id"], name: "canto_memories_index", unique: true
  end

  create_table "cantoes", force: :cascade do |t|
    t.text "text"
    t.string "prosomeion_title"
    t.string "language_code", null: false
    t.integer "tone"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "alphabeth_code", null: false
    t.string "author"
    t.string "description"
    t.string "ref_title"
    t.index ["title", "language_code"], name: "index_cantoes_on_title_and_language_code"
  end

  create_table "descriptions", force: :cascade do |t|
    t.string "text", null: false
    t.string "language_code", null: false
    t.integer "describable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "describable_type", null: false
    t.string "alphabeth_code", null: false
    t.string "type"
    t.index ["describable_id", "describable_type", "alphabeth_code", "text"], name: "describable_alphabeth_index", unique: true
  end

  create_table "event_memoes", force: :cascade do |t|
    t.string "type_class"
    t.string "type_number"
    t.integer "memo_id", null: false
    t.integer "event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "happened_at"
    t.integer "memory_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "place_id"
    t.integer "item_id"
    t.string "person_name"
    t.integer "type_number"
    t.string "about_string"
    t.string "tezo_string"
    t.string "order"
    t.string "council"
    t.index ["type", "memory_id", "item_id"], name: "index_events_on_item_id_and_type_and_memory_id"
    t.index ["type", "memory_id"], name: "index_events_on_subject_and_type_and_memory_id"
  end

  create_table "item_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "item_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "url", null: false
    t.string "language_code"
    t.integer "info_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alphabeth_code"
    t.string "info_type", null: false
  end

  create_table "memoes", force: :cascade do |t|
    t.string "happened_at"
    t.string "date"
    t.integer "before"
    t.integer "after"
    t.integer "inevening"
    t.integer "memory_id", null: false
    t.integer "calendary_id"
    t.index ["date"], name: "index_memoes_on_date"
    t.index ["happened_at"], name: "index_memoes_on_happened_at"
    t.index ["memory_id", "calendary_id", "date"], name: "index_memoes_on_memory_calendary_and_date", unique: true
  end

  create_table "memories", force: :cascade do |t|
    t.string "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "covers_to_id"
    t.string "view_string"
    t.string "quantity"
    t.string "order"
    t.string "council"
    t.integer "base_year"
    t.index ["short_name"], name: "index_memories_on_short_name", unique: true
  end

  create_table "memory_names", force: :cascade do |t|
    t.integer "memory_id", null: false
    t.integer "name_id", null: false
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mode"
    t.boolean "feasible", default: false, null: false
    t.index ["memory_id", "name_id", "state"], name: "index_memory_names_on_memory_id_and_name_id_and_state", unique: true
  end

  create_table "mentions", force: :cascade do |t|
    t.integer "calendary_id", null: false
    t.integer "event_id", null: false
    t.string "year_date", null: false
    t.string "add_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendary_id", "event_id", "year_date"], name: "dated_calendary_event_index", unique: true
  end

  create_table "names", force: :cascade do |t|
    t.string "text", null: false
    t.string "type", default: "", null: false
    t.string "language_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "similar_to_id"
    t.string "alphabeth_code", null: false
    t.index ["text", "type", "alphabeth_code"], name: "index_names_on_text_and_type_and_alphabeth_code", unique: true
  end

  create_table "places", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_cantoes", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "canto_id", null: false
    t.index ["service_id", "canto_id"], name: "index_service_cantoes_on_service_id_and_canto_id", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.string "language_code", null: false
    t.integer "info_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alphabeth_code", null: false
    t.text "text"
    t.string "text_format"
    t.string "gospel"
    t.string "apostle"
    t.string "author"
    t.string "source"
    t.string "description"
    t.string "info_type", null: false
    t.string "ref_title"
    t.integer "tone"
    t.index ["name", "alphabeth_code"], name: "index_services_on_name_and_alphabeth_code", unique: true
  end

  create_table "slugs", force: :cascade do |t|
    t.string "text", null: false
    t.string "sluggable_type"
    t.integer "sluggable_id"
    t.index ["sluggable_type", "sluggable_id"], name: "index_slugs_on_sluggable_type_and_sluggable_id"
    t.index ["text"], name: "index_slugs_on_text", unique: true
  end

end
