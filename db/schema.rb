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

ActiveRecord::Schema.define(version: 2019_02_19_041741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acquisitions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "master_target_id"
    t.integer "project_id"
    t.integer "mou_id"
    t.datetime "proposal_created_date"
    t.datetime "first_payment_date"
    t.integer "spent_time_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_target_id"], name: "index_acquisitions_on_master_target_id"
    t.index ["user_id"], name: "index_acquisitions_on_user_id"
  end

  create_table "active_achievement_monthlies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "master_target_id", null: false
    t.integer "nilai_proposal"
    t.integer "nilai_sf"
    t.integer "hit_rate"
    t.integer "one_time"
    t.integer "nilai_renewal"
    t.integer "cross_selling"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_target_id"], name: "index_active_achievement_monthlies_on_master_target_id"
    t.index ["user_id"], name: "index_active_achievement_monthlies_on_user_id"
  end

  create_table "master_targets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "nominal", null: false
    t.integer "hit_rate", null: false
    t.integer "one_time", null: false
    t.integer "periodic", null: false
    t.integer "nominal_tolerance", null: false
    t.integer "acquisition", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_master_targets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role", default: "", null: false
    t.text "positions", default: "", null: false
    t.text "members", default: "", null: false
    t.string "redmine_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "authentication_token"
    t.string "username"
    t.string "division"
    t.string "gsm"
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
