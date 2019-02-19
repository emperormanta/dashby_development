class Types::TargetType < GraphQL::Schema::Object
  field :id, Integer, null: false
  field :user_id, Integer, null: false
  field :division, String, null: false
  field :nominal, Integer, null: true
  field :hit_rate, Integer, null: true
  field :one_time, Integer, null: true
  field :periodic, Integer, null: true
  field :nominal_tolerance, Integer, null: true
  field :acquisition, Integer, null: true

  def division
    data = []
    user = User.find_by(id: object.user_id)
    divisions = JSON.parse(user.division)
    divisions.each do |division|
      data.push(division["name"])
    end
    data = data.join(", ")
    return data
  end
  
end