class CurrentUser < ApplicationRecord
    def self.save_current_user(auth)
        user = User.where(email: auth["email"]).first_or_create
        user.full_name = auth["full_name"]
        user.email = auth["email"]
        user.role = "USR"
        user.positions = auth["positions"]
        user.members = auth["members"]
        user.division = auth["user_divisions"]
        user.gsm = auth["gsm"]
        user.authentication_token = auth["authentication_token"]
        user.password = SecureRandom.hex
        user.save
        return user
    end
end