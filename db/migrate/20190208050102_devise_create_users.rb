class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
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
end
