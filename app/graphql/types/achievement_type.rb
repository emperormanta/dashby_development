class Types::AchievementType < GraphQL::Schema::Object
  field :target_achievement, Int, null: true
  field :current_achievement, Int, null: true
  field :percentage, Float, null: true
  field :last_month_achievement, Int, null: true
end