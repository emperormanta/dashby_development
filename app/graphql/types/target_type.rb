class Types::TargetType < GraphQL::Schema::Object
  field :user_id, String, null: true
  field :nominal, Integer, null: true
  field :hit_rate, Integer, null: true
  field :one_time, Integer, null: true
  field :periodic, Integer, null: true
  field :nominal_tolerance, Integer, null: false
  field :acquisition, Integer, null: false
end