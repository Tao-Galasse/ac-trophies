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

ActiveRecord::Schema[8.1].define(version: 2026_04_08_132103) do
  create_table "earned_trophies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "earned_at"
    t.integer "game_id", null: false
    t.integer "psn_trophy_id", null: false
    t.integer "trophy_group_id", null: false
    t.string "trophy_type"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_earned_trophies_on_game_id"
    t.index ["trophy_group_id"], name: "index_earned_trophies_on_trophy_group_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "platform", null: false
    t.string "psn_communication_id", null: false
    t.date "release_date", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_communication_id"], name: "index_games_on_psn_communication_id", unique: true
  end

  create_table "trophy_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.string "name", null: false
    t.string "psn_group_id", null: false
    t.date "release_date", null: false
    t.integer "total_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_trophy_groups_on_game_id"
  end

  add_foreign_key "earned_trophies", "games"
  add_foreign_key "earned_trophies", "trophy_groups"
  add_foreign_key "trophy_groups", "games"
end
