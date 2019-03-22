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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "question_id", null: false
    t.integer "trinomial_option_id"
    t.integer "binomial_option_id"
    t.text "freetext"
    t.decimal "numerical"
    t.decimal "percentage"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "assessment_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "assessment_types_name_key", unique: true
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.integer "assessment_type_id", null: false
    t.integer "organisation_id", null: false
    t.integer "user_id", null: false
    t.datetime "started_at", default: -> { "now()" }, null: false
    t.boolean "completed", default: false
    t.datetime "completed_at"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "binomial_options", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "binomial_options_name_key", unique: true
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "countries_name_key", unique: true
  end

  create_table "framework_compliances", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "framework_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "frameworks", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "frameworks_name_key", unique: true
  end

  create_table "mappings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "weight", default: 0
    t.integer "question_id", null: false
    t.integer "framework_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "organisations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "country_id", null: false
    t.integer "region_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "organisations_name_key", unique: true
  end

  create_table "question_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "question_categories_name_key", unique: true
  end

  create_table "question_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "question_types_name_key", unique: true
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.string "question", null: false
    t.integer "section_id", null: false
    t.integer "question_category_id", null: false
    t.integer "question_type_id", null: false
    t.integer "index"
    t.string "reference"
    t.string "mcss_reference"
    t.string "guidance"
    t.boolean "visible", default: true
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["question", "section_id"], name: "question_section_unique_index", unique: true
  end

  create_table "questionsets", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "assessment_type_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "questionsets_name_key", unique: true
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "regions_name_key", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "role_name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["role_name"], name: "roles_role_name_key", unique: true
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "guidance"
    t.integer "questionset_id", null: false
    t.boolean "compliance", default: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "sections_name_key", unique: true
  end

  create_table "trinomial_options", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name"], name: "trinomial_options_name_key", unique: true
  end

  create_table "user_roles", primary_key: ["user_id", "role_id"], force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.datetime "grant_date", default: -> { "now()" }, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.integer "organisation_id", null: false
    t.string "name"
    t.string "mobile"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "users_email_key", unique: true
  end

  add_foreign_key "answers", "assessments", name: "answer_assessment_id_fkey"
  add_foreign_key "answers", "binomial_options", name: "answer_binomial_option_id_fkey"
  add_foreign_key "answers", "questions", name: "answer_question_id_fkey"
  add_foreign_key "answers", "trinomial_options", name: "answer_trinomial_option_id_fkey"
  add_foreign_key "assessments", "assessment_types", name: "assessment_type_id_fkey"
  add_foreign_key "assessments", "organisations", name: "assessment_organisation_id_fkey"
  add_foreign_key "assessments", "users", name: "assessment_user_id_fkey"
  add_foreign_key "framework_compliances", "frameworks", name: "mapping_framework_id_fkey"
  add_foreign_key "framework_compliances", "questions", name: "mapping_question_id_fkey"
  add_foreign_key "mappings", "frameworks", name: "mapping_framework_id_fkey"
  add_foreign_key "mappings", "questions", name: "mapping_question_id_fkey"
  add_foreign_key "organisations", "countries", name: "organisations_country_id_fkey"
  add_foreign_key "organisations", "regions", name: "organisations_region_id_fkey"
  add_foreign_key "questions", "question_categories", name: "question_category_id_fkey"
  add_foreign_key "questions", "question_types", name: "question_type_id_fkey"
  add_foreign_key "questions", "sections", name: "question_section_id_fkey"
  add_foreign_key "questionsets", "assessment_types", name: "questionset_assessment_type_id_fkey"
  add_foreign_key "sections", "questionsets", name: "section_questionset_id_fkey"
  add_foreign_key "user_roles", "roles", name: "account_role_role_id_fkey"
  add_foreign_key "user_roles", "users", name: "account_role_user_id_fkey"
  add_foreign_key "users", "organisations", name: "users_organisation_id_fkey"
end
