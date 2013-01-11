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

ActiveRecord::Schema.define(version: 20130110225911) do

  create_table "format_infos", force: true do |t|
    t.integer  "phrase_id",              null: false
    t.integer  "position",               null: false
    t.string   "format_class", limit: 3, null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "format_infos", ["phrase_id", "position"], name: "index_format_infos_on_phrase_id_and_position", unique: true

  create_table "languages", force: true do |t|
    t.string "iso_code", limit: 5, null: false
    t.string "name",               null: false
  end

  add_index "languages", ["iso_code"], name: "index_languages_on_iso_code", unique: true

  create_table "phrases", force: true do |t|
    t.integer  "sourcemod_plugin_id",             null: false
    t.string   "name",                            null: false
    t.string   "format"
    t.integer  "translations_count",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phrases", ["sourcemod_plugin_id", "name"], name: "index_phrases_on_sourcemod_plugin_id_and_name", unique: true

  create_table "plugin_tags", force: true do |t|
    t.integer "sourcemod_plugin_id", null: false
    t.integer "tag_id",              null: false
  end

  add_index "plugin_tags", ["tag_id", "sourcemod_plugin_id"], name: "index_plugin_tags_on_tag_id_and_sourcemod_plugin_id", unique: true

  create_table "sourcemod_plugins", force: true do |t|
    t.integer  "user_id",                   null: false
    t.string   "name",                      null: false
    t.string   "filename",                  null: false
    t.integer  "phrases_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "completed"
    t.float    "attempted"
  end

  add_index "sourcemod_plugins", ["user_id"], name: "index_sourcemod_plugins_on_user_id"

  create_table "tags", force: true do |t|
    t.string "name", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "translations", force: true do |t|
    t.integer  "phrase_id",                               null: false
    t.integer  "language_id",                             null: false
    t.integer  "user_id",                                 null: false
    t.string   "text",                                    null: false
    t.integer  "votes_count",             default: 0,     null: false
    t.integer  "translation_flags_count", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "imported",                default: false
  end

  add_index "translations", ["imported"], name: "index_translations_on_imported"

  create_table "user_languages", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "language_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider",                   null: false
    t.string   "uid",                        null: false
    t.string   "name",                       null: false
    t.string   "time_zone",  default: "UTC", null: false
    t.boolean  "admin",      default: false, null: false
    t.boolean  "moderator",  default: false, null: false
    t.boolean  "banned",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
