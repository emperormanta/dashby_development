class Types::TargetType < GraphQL::Schema::Object
  field :user_id, String, null: true
  field :user_name, String, null: true
  field :user_division, String, null: true
  field :nominal, Integer, null: true
  field :hit_rate, Integer, null: true
  field :one_time, Integer, null: true
  field :periodic, Integer, null: true
  field :nominal_tolerance, Integer, null: false
  field :acquisition, Integer, null: false

  def user_name
    user_name = get_user(object.user_id).full_name
    return user_name
  end
  
  def user_division
    user = get_user(object.user_id).division
    return JSON.parse(user.to_str).first["abbreviation"]
  end

  private
  def get_user(id)
    return User.find_by(id: id)
  end
end