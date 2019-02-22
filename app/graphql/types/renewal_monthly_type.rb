class Types::RenewalMonthlyType < GraphQL::Schema::Object
  field :target, Int, null: true
  field :current, Int, null: true
  field :percentage, Int, null: true
  field :last_month, Int, null: true
  field :upcross, Int, null: true
end