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

ActiveRecord::Schema.define(version: 2021_12_10_112939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternate_titles", force: :cascade do |t|
    t.string "imdb_id"
    t.integer "ordering"
    t.string "name"
    t.string "region"
    t.string "language"
    t.string "release_types"
    t.string "imdb_attributes"
    t.boolean "original"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["imdb_id"], name: "index_alternate_titles_on_imdb_id"
  end

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

  create_table "datasets", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.boolean "fetched", default: false
    t.integer "completed", default: 0
    t.integer "total", default: 0
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "directings", force: :cascade do |t|
    t.string "title_imdb_id"
    t.string "director_imdb_id"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["director_imdb_id"], name: "index_directings_on_director_imdb_id"
    t.index ["title_imdb_id"], name: "index_directings_on_title_imdb_id"
  end

  create_table "imdb_ratings", force: :cascade do |t|
    t.string "title_imdb_id"
    t.float "average_rating"
    t.integer "num_votes"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["title_imdb_id"], name: "index_imdb_ratings_on_title_imdb_id"
  end

  create_table "principals", force: :cascade do |t|
    t.string "title_imdb_id"
    t.string "artist_imdb_id"
    t.integer "ordering"
    t.string "category"
    t.string "job"
    t.string "characters"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["artist_imdb_id"], name: "index_principals_on_artist_imdb_id"
    t.index ["title_imdb_id"], name: "index_principals_on_title_imdb_id"
  end

  create_table "title_episodes", force: :cascade do |t|
    t.string "title_imdb_id"
    t.string "episode_imdb_id"
    t.integer "season_number"
    t.integer "episode_number"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["episode_imdb_id"], name: "index_title_episodes_on_episode_imdb_id"
    t.index ["title_imdb_id"], name: "index_title_episodes_on_title_imdb_id"
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

  create_table "writings", force: :cascade do |t|
    t.string "title_imdb_id"
    t.string "writer_imdb_id"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["title_imdb_id"], name: "index_writings_on_title_imdb_id"
    t.index ["writer_imdb_id"], name: "index_writings_on_writer_imdb_id"
  end

  add_foreign_key "alternate_titles", "titles", column: "imdb_id", primary_key: "imdb_id"
  add_foreign_key "directings", "artists", column: "director_imdb_id", primary_key: "imdb_id"
  add_foreign_key "directings", "titles", column: "title_imdb_id", primary_key: "imdb_id"
  add_foreign_key "imdb_ratings", "titles", column: "title_imdb_id", primary_key: "imdb_id"
  add_foreign_key "principals", "artists", column: "artist_imdb_id", primary_key: "imdb_id"
  add_foreign_key "principals", "titles", column: "title_imdb_id", primary_key: "imdb_id"
  add_foreign_key "title_episodes", "titles", column: "episode_imdb_id", primary_key: "imdb_id"
  add_foreign_key "title_episodes", "titles", column: "title_imdb_id", primary_key: "imdb_id"
  add_foreign_key "writings", "artists", column: "writer_imdb_id", primary_key: "imdb_id"
  add_foreign_key "writings", "titles", column: "title_imdb_id", primary_key: "imdb_id"
end
