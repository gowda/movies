# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_09_145220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "birth_year"
    t.string "death_year"
    t.string "imdb_id"
    t.string "primary_profession"
    t.string "known_for_titles"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["imdb_id"], name: "index_artists_on_imdb_id", unique: true
  end

  create_table "titles", force: :cascade do |t|
    t.string "imdb_id"
    t.string "category"
    t.string "name"
    t.string "original_name"
    t.boolean "adult"
    t.string "start_year"
    t.string "end_year"
    t.integer "runtime_minutes"
    t.string "genres"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["imdb_id"], name: "index_titles_on_imdb_id", unique: true
  end

end
