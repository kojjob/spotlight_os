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

ActiveRecord::Schema[8.0].define(version: 2025_05_27_163444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "lead_id", null: false
    t.bigint "assistant_id", null: false
    t.datetime "scheduled_at"
    t.integer "duration"
    t.string "status"
    t.string "external_id"
    t.string "external_link"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_appointments_on_assistant_id"
    t.index ["lead_id", "status"], name: "index_appointments_on_lead_id_and_status"
    t.index ["lead_id"], name: "index_appointments_on_lead_id"
    t.index ["scheduled_at", "status"], name: "index_appointments_on_scheduled_at_and_status"
  end

  create_table "assistants", force: :cascade do |t|
    t.string "name"
    t.string "tone"
    t.string "role"
    t.text "script"
    t.string "voice_id"
    t.string "language"
    t.boolean "active"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language"], name: "index_assistants_on_language"
    t.index ["user_id", "active"], name: "index_assistants_on_user_id_and_active"
    t.index ["user_id"], name: "index_assistants_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "lead_id", null: false
    t.bigint "assistant_id", null: false
    t.string "source"
    t.string "status"
    t.integer "score"
    t.integer "duration"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id", "status"], name: "index_conversations_on_assistant_id_and_status"
    t.index ["assistant_id"], name: "index_conversations_on_assistant_id"
    t.index ["created_at", "status"], name: "index_conversations_on_created_at_and_status"
    t.index ["lead_id"], name: "index_conversations_on_lead_id"
    t.index ["score"], name: "index_conversations_on_score"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "company"
    t.string "source"
    t.string "status"
    t.integer "score"
    t.boolean "qualified"
    t.jsonb "metadata"
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_leads_on_assistant_id"
    t.index ["email"], name: "index_leads_on_email"
    t.index ["name"], name: "index_leads_on_name"
    t.index ["qualified", "created_at"], name: "index_leads_on_qualified_and_created_at"
    t.index ["source"], name: "index_leads_on_source"
    t.index ["status", "score"], name: "index_leads_on_status_and_score"
  end

  create_table "transcripts", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.text "content"
    t.string "speaker"
    t.string "sentiment"
    t.float "confidence"
    t.float "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id", "speaker"], name: "index_transcripts_on_conversation_id_and_speaker"
    t.index ["conversation_id"], name: "index_transcripts_on_conversation_id"
    t.index ["sentiment"], name: "index_transcripts_on_sentiment"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.string "company"
    t.string "role"
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "appointments", "assistants"
  add_foreign_key "appointments", "leads"
  add_foreign_key "assistants", "users"
  add_foreign_key "conversations", "assistants"
  add_foreign_key "conversations", "leads"
  add_foreign_key "leads", "assistants"
  add_foreign_key "transcripts", "conversations"
end
