class Types::MonthlyType < GraphQL::Schema::Object
  # For general monthly data type
  field :current, Int, null: true
  field :target, Int, null: true
  field :percentage, Float, null: true
  field :last_month, Int, null: true
end