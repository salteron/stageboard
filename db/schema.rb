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

ActiveRecord::Schema.define(version: 20151105171258) do

  create_table "deploys", force: :cascade do |t|
    t.string   "branch",       limit: 100, null: false
    t.integer  "initiated_by"
    t.datetime "finished_at"
    t.integer  "stage_id",                 null: false
  end

  add_index "deploys", ["stage_id", "finished_at"], name: "index_deploys_on_stage_id_and_finished_at", unique: true

  create_table "stages", force: :cascade do |t|
    t.string  "url",     limit: 100,                  null: false
    t.string  "uuid",    limit: 36,                   null: false
    t.text    "comment", limit: 1000
    t.boolean "locked",               default: false, null: false
  end

  add_index "stages", ["url"], name: "index_stages_on_url", unique: true
  add_index "stages", ["uuid"], name: "index_stages_on_uuid", unique: true

end
